import Foundation
import os

public class Logger: ObservableObject {    
    // MARK: - Singleton
    public static let shared = Logger()
    
    internal var config: LoggerConfig = .defaultConfig
    
    public var logs: [LogItem] = []
    
    // MARK: Console Intercepting
    internal var originalSTDOUTDescriptor: Int32
    internal var originalSTDERRDescriptor: Int32
    
    internal let stdoutInputPipe = Pipe()
    internal let stdoutOutputPipe = Pipe()
    
    internal let stderrInputPipe = Pipe()
    internal let stderrOutputPipe = Pipe()
    
    public var consoleOutput: String = ""
    public var stdout: String = ""
    public var stderr: String = ""
    
    var isInterceptingConsoleOutput: Bool = false
    
    init() {
        originalSTDOUTDescriptor = FileHandle.standardOutput.fileDescriptor
        originalSTDERRDescriptor = FileHandle.standardError.fileDescriptor
        hijackConsole()
    }
    
    func log(_ item: LogItem) {
        switch item.level {
        case .fatal:
            let desc = item.complexDescription
            appendLog(log: item, description: desc)
            os_log(.fault, "%{public}s", desc)
            Swift.fatalError(item.complexDescription)
        case .error:
            let desc = item.description
            appendLog(log: item, description: desc)
            os_log(.error, "%{public}s", desc)
        case .warn, .working, .success:
            let desc = item.description
            appendLog(log: item, description: desc)
            os_log(.default, "%{public}s", desc)
        case .info:
            let desc = item.description
            appendLog(log: item, description: desc)
            os_log(.info, "%{public}s", desc)
        case .debug:
            #if DEBUG
            let desc = item.description
            appendLog(log: item, description: desc)
            os_log(.debug, "%{public}s", desc)
            #endif
        }
    }
    
    private func appendLog(log: LogItem, description: String) {
        DispatchQueue.main.async {
            self.logs.append(log)
            
            if self.logs.count > self.config.historyLength {
                self.logs.removeFirst()
            }
            
            self.consoleOutput.append(description)
            self.consoleOutput.append("\n")
            self.stdout.append(description)
            self.stdout.append("\n")
        }
    }
    
    /// New Implementation from Michael Allman and his work in https://github.com/mallman/HydrogenBomb/blob/master/HydrogenBomb/Logger.swift
    /// An issue was raised where the logger would block the main thread, the above is the solution to this.
    /// Issue in question: https://github.com/ActuallyTaylor/HydrogenReporter/issues/1
    ///
    /// Original Resource
    /// https://stackoverflow.com/a/63208455/14886210
    /// https://phatbl.at/2019/01/08/intercepting-stdout-in-swift.html
    /// Set up an intercept for the Stdout which redirects it here to then be printed to the console visible to Hydrogen
    public func hijackConsole() {
        print("Starting Console Hijack...")
        isInterceptingConsoleOutput = true
        
        // MARK: STDOUT Intercepting
        // Copy STDOUT file descriptor to outputPipe for writing strings back to STDOUT
        dup2(originalSTDOUTDescriptor, stdoutOutputPipe.fileHandleForWriting.fileDescriptor)
        
        // Intercept STDOUT with inputPipe
        dup2(stdoutInputPipe.fileHandleForWriting.fileDescriptor, originalSTDOUTDescriptor)
        
        // MARK: STDERR Intercepting
        // Copy STDOUT file descriptor to outputPipe for writing strings back to STDOUT
        dup2(originalSTDERRDescriptor, stderrOutputPipe.fileHandleForWriting.fileDescriptor)
        
        // Intercept STDOUT with inputPipe
        dup2(stderrInputPipe.fileHandleForWriting.fileDescriptor, originalSTDERRDescriptor)
        
        // MARK: Thread based reading and writing
        // Decouple reading from writing by reading on a separate thread
        // This ensures that writing to stdout/stderr does not block while we wait
        // to read from it (on the same thread!)
        let ioThread = Thread { [unowned self] in
            stdoutInputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: stdoutInputPipe.fileHandleForReading , queue: nil) { notification in
                let output = self.stdoutInputPipe.fileHandleForReading.availableData
                let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
                
                DispatchQueue.main.async {
                    self.consoleOutput += outputString
                    self.stdout += outputString
                }
                
                self.stdoutOutputPipe.fileHandleForWriting.write(output)
                self.stdoutInputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            }
            
            stderrInputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            
            NotificationCenter.default.addObserver(forName: NSNotification.Name.NSFileHandleDataAvailable, object: stderrInputPipe.fileHandleForReading , queue: nil) { notification in
                let output = self.stderrInputPipe.fileHandleForReading.availableData
                let outputString = String(data: output, encoding: String.Encoding.utf8) ?? ""
                
                DispatchQueue.main.async {
                    self.consoleOutput += outputString
                    self.stderr += outputString
                }
                
                self.stderrOutputPipe.fileHandleForWriting.write(output)
                self.stderrInputPipe.fileHandleForReading.waitForDataInBackgroundAndNotify()
            }
            // We need to add and run a runloop to this thread to ensure it doesn't exit immediately
            // Also, the documentation for asynchronous reading from FileHandle states that
            // asynchronous reads must be performed from a thread with a runloop
            RunLoop.current.run()
        }
        
        ioThread.start()
        
        print("Completed Console Hijack - Welcome to the Hydrogen Console 👋")
    }
    
    public func dumpToText() -> String {
        let currentDate = config.dateFormatter().string(from: Date())
        var compiledLogs: String = "\(config.applicationName) logs for \(currentDate)\n"
        
        let totalLogs = logs.count
        let totalFatalLogs = logs.filter({$0.level == .fatal}).count
        let totalErrorLogs = logs.filter({$0.level == .error}).count
        let totalWarnLogs = logs.filter({$0.level == .warn}).count
        let totalInfoLogs = logs.filter({$0.level == .info}).count
        let totalSuccessLogs = logs.filter({$0.level == .success}).count
        let totalWorkingLogs = logs.filter({$0.level == .working}).count
        let totalDebugLogs = logs.filter({$0.level == .debug}).count
        
        let newTotalLogs = totalLogs == 0 ? 1 : totalLogs
        // Statistics Data to be logged at the top of the file
        compiledLogs.append("--- ✨ Total Logs: \(logs.count) ---\n")
        compiledLogs.append("--- \(LogLevel.fatal.emoji()) Total Fatal Error Logs: \(totalFatalLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.error.emoji()) Total Error Logs: \(totalErrorLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.warn.emoji()) Total Warn Logs: \(totalWarnLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.info.emoji()) Total Info Logs: \(totalInfoLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.success.emoji()) Total Success Logs: \(totalSuccessLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.working.emoji()) Total Working Logs: \(totalWorkingLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.debug.emoji()) Total Debug Logs: \(totalDebugLogs) ---\n")
        compiledLogs.append("--- Fatal % \(getPercent(value: totalFatalLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("- Error % \(getPercent(value: totalErrorLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("- Warn % \(getPercent(value: totalWarnLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("- Info % \(getPercent(value: totalInfoLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("- Success % \(getPercent(value: totalSuccessLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("- Working % \(getPercent(value: totalWorkingLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("- Debug % \(getPercent(value: totalDebugLogs, divisor: newTotalLogs)) ")
        compiledLogs.append("---\n")
        
        compiledLogs.append("=== START LOGS ===\n")
        
        compiledLogs.append(logs.compactMap({$0.complexDescription}).joined(separator: "\n"))
        
        compiledLogs.append("\n=== END LOGS ===")
        
        compiledLogs.append("\n=== RAW CONSOLE ===\n")
        compiledLogs.append(consoleOutput)
        compiledLogs.append("\n=== END RAW CONSOLE ===")

        return compiledLogs
    }
    
    public func dumpToFile() throws -> URL {
        let currentDate = config.dateFormatter().string(from: Date())
        let compiledLogs = dumpToText()
        
        var url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("logs", isDirectory: true)
        
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        
        let fileName = "log[\(currentDate)].log"
        url.appendPathComponent(fileName)
        
        try compiledLogs.write(toFile: url.path, atomically: true, encoding: .utf8)
        
        return url
    }
    
    func getPercent(value: Int, divisor: Int) -> String {
        return String(format: "%.2f", (Double(value) / Double(divisor)))
    }
}

// MARK: Getter's and Setters
extension Logger {
    public func setLoggerConfig(config: LoggerConfig) {
        self.config = config
    }
    
    public func getLoggerConfig() -> LoggerConfig {
        return config
    }
}

// /MARK: Log Function
public func LOG(_ items: Any...,
                separator: String = " ",
                terminator: String = "",
                level: LogLevel = Logger.shared.getLoggerConfig().defaultLevel,
                complexity: LogComplexity = Logger.shared.getLoggerConfig().defaultComplexity,
                file: String = #file, line: UInt = #line, function: String = #function) {
    Logger.shared.log(LogItem(creationData: Date(), items: items, separator: separator, terminator: terminator, level: level, complexity: complexity, file: file, line: line, function: function, leader: Logger.shared.getLoggerConfig().leadingEmoji))
}
