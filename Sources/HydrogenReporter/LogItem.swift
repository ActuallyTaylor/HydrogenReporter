import Foundation

public struct LogItem: CustomStringConvertible, Identifiable {
    public var id: UUID = UUID()
    
    let creationData: Date
    let items: [Any]
    let separator: String
    let terminator: String
    
    public let level: LogLevel
    let complexity: LogComplexity
    
    let file: String
    let line: UInt
    let function: String
    
    let leader: String
    
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
        var outputStream: LoggerOutputStream = LoggerOutputStream(prefix: "\(Logger.shared.config.leadingEmoji) \(emoji)")
        print(items, separator: separator, terminator: terminator, to: &outputStream)
        
        return outputStream.retrieveContent()
    }
    
    var complexDescription: String {
        var outputStream: LoggerOutputStream = LoggerOutputStream(prefix: "\(Logger.shared.config.leadingEmoji) \(emoji)")
        print(items, separator: separator, to: &outputStream)
        #if DEBUG
        outputStream.write(" - \(file) @ line \(line), in function \(function)")
        #else
        outputStream.write(" - @ line \(line), in function \(function)")
        #endif
        
        return outputStream.retrieveContent()
    }
}
