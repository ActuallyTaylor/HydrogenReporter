import Foundation

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
