import Foundation

// MARK: Logger text output for using print
public struct LoggerOutputStream: TextOutputStream {
    private var content: String
    
    init(prefix: String) {
        content = prefix + " "
    }
    
    public mutating func write(_ string: String) {
        content.append(string)
    }
    
    public func retrieveContent() -> String {
        return content
    }
}
