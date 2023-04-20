//
//  Logger.swift
//  
//
//  Created by Taylor Lineman on 4/19/23.
//

import Foundation
import os

public class Logger: ObservableObject {
    // MARK: Supporting Structures
    public enum LogLevel: String, Codable {
        case fatal
        case error
        case warn
        case info
        case success
        case working
        case debug
        
        public func emoji() -> String {
            switch self {
            case .fatal: return "🛑"
            case .error: return "🥲"
            case .warn:  return "⚠️"
            case .info:  return "🤖"
            case .success: return "✅"
            case .working:  return "⚙️"
            case .debug: return "🔵"
            }
        }
    }

    // MARK: Logger Complexity
    public enum LogComplexity: String, Codable {
        case simple
        case complex
    }
    
    // MARK: Logger Config
    public struct LoggerConfig: Codable {
        let applicationName: String
        
        let defaultLevel: LogLevel
        let defaultComplexity: LogComplexity
        let leadingEmoji: String
        let locale: String
        let timezone: String
        let dateFormat: String
        
        let historyLength: Int
        
        func dateFormatter() -> DateFormatter {
            let formatter = DateFormatter()
            formatter.calendar = Calendar(identifier: .iso8601)
            formatter.locale = Locale(identifier: locale)
            formatter.timeZone = TimeZone(identifier: timezone)
            formatter.dateFormat = dateFormat
            return formatter
        }
        
        static let defaultConfig: LoggerConfig =  .init(applicationName: "Swifty Debug", defaultLevel: .info, defaultComplexity: .simple, leadingEmoji: "⚫️", locale: "en_US", timezone: "utc", dateFormat: "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", historyLength: 100000)
    }
    
    public struct LogItem: Codable, CustomStringConvertible, Identifiable {
        public var id: UUID = UUID()
        
        let creationData: Date
        let items: [String]
        let level: LogLevel
        let complexity: LogComplexity
        
        let file: String
        let line: UInt
        let function: String
        
        var emoji: String {
            return level.emoji()
        }
        
        public var description: String {
            switch complexity {
            case .simple:
                return simpleDescription
            case .complex:
                return complexDescription
            }
        }
        
        var simpleDescription: String {
            let joinedArray: String = items.joined(separator:", ")
            return "\(emoji) \(joinedArray)"
        }
        
        var complexDescription: String {
            let joinedArray: String = items.joined(separator:", ")
            return "\(emoji) \(joinedArray) - \(file) @ line \(line), in function \(function)"
        }
    }
    
    // MARK: - Singleton
    static let shared = Logger()

    private var config: LoggerConfig = .defaultConfig
    
    @Published var logs: [LogItem] = []
        
    func log(_ item: LogItem) {
        appendLog(log: item)
        if item.level != .fatal {
            // Non-fatal Flaw so check complexity
            os_log("%{public}s", item.description)
        } else {
            // Fatal Fail
            os_log("%{public}s", item.complexDescription)
            Swift.fatalError(item.complexDescription)
        }
    }
    
    private func appendLog(log: LogItem) {
        logs.append(log)
        
        if logs.count > config.historyLength {
            logs.removeFirst()
        }
    }
    
    private func dumpToFile() throws {
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

        // Statistics Data to be logged at the top of the file
        compiledLogs.append("--- ✨ Total Logs: \(logs.count) ---\n")
        compiledLogs.append("--- \(LogLevel.fatal.emoji()) Total Fatal Error Logs: \(totalFatalLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.error.emoji()) Total Error Logs: \(totalErrorLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.warn.emoji()) Total Warn Logs: \(totalErrorLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.info.emoji()) Total Info Logs: \(totalInfoLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.success.emoji()) Total Success Logs: \(totalSuccessLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.working.emoji()) Total Working Logs: \(totalWorkingLogs) ---\n")
        compiledLogs.append("--- \(LogLevel.debug.emoji()) Total Debug Logs: \(totalDebugLogs) ---\n")
        compiledLogs.append("--- Fatal % \(totalFatalLogs / totalLogs) ")
        compiledLogs.append("- Error % \(totalErrorLogs / totalLogs) ")
        compiledLogs.append("- Warn % \(totalWarnLogs / totalLogs) ")
        compiledLogs.append("- Info % \(totalInfoLogs / totalLogs) ")
        compiledLogs.append("- Success % \(totalSuccessLogs / totalLogs) ")
        compiledLogs.append("- Working % \(totalWorkingLogs / totalLogs) ")
        compiledLogs.append("- Debug % \(totalDebugLogs / totalLogs) ")
        compiledLogs.append("---\n")
        
        compiledLogs.append("=== START LOGS ===")

        compiledLogs.append(logs.compactMap({$0.complexDescription}).joined(separator: "\n"))
                
        compiledLogs.append("=== END LOGS ===")

        var url = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent("logs", isDirectory: true)
        try FileManager.default.createDirectory(at: url, withIntermediateDirectories: true, attributes: [:])
        let fileName = "log[\(currentDate)]"
        url.appendPathComponent(fileName)
        
        try compiledLogs.write(toFile: url.path, atomically: true, encoding: .utf8)
    }
}



// /MARK: Log Function
func LOG(_ items: String...,
         level: Logger.LogLevel = Logger.LoggerConfig.defaultConfig.defaultLevel,
         complexity: Logger.LogComplexity = Logger.LoggerConfig.defaultConfig.defaultComplexity,
         file: String = #file, line: UInt = #line, function: String = #function) {
    Logger.shared.log(Logger.LogItem(creationData: Date(), items: items, level: level, complexity: complexity, file: file, line: line, function: function))
}
