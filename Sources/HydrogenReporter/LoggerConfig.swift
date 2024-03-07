import Foundation

// MARK: Logger Config
public struct LoggerConfig: Codable {
    let applicationName: String
    
    public let defaultLevel: LogLevel
    public let defaultComplexity: LogComplexity
    let leadingEmoji: String
    let locale: String
    let timezone: String
    let dateFormat: String
    
    let historyLength: Int
    let sendHydrogenLogsToReporterConsole: Bool
    
    public static let defaultConfig: LoggerConfig =  .init(applicationName: "Hydrogen Reporter", defaultLevel: .info, defaultComplexity: .simple, leadingEmoji: "⚫️")
    
    public init(applicationName: String, defaultLevel: LogLevel, defaultComplexity: LogComplexity, leadingEmoji: String, locale: String = "en_US", timezone: String = "en_US", dateFormat: String = "yyyy-MM-dd'T'HH:mm:ss.SSSXXXXX", historyLength: Int = 100000, sendHydrogenLogsToReporterConsole: Bool = true) {
        self.applicationName = applicationName
        self.defaultLevel = defaultLevel
        self.defaultComplexity = defaultComplexity
        self.leadingEmoji = leadingEmoji
        self.locale = locale
        self.timezone = timezone
        self.dateFormat = dateFormat
        self.historyLength = historyLength
        self.sendHydrogenLogsToReporterConsole = sendHydrogenLogsToReporterConsole
    }
    
    
    func dateFormatter() -> DateFormatter {
        let formatter = DateFormatter()
        formatter.calendar = Calendar(identifier: .iso8601)
        formatter.locale = Locale(identifier: locale)
        formatter.timeZone = TimeZone(identifier: timezone)
        formatter.dateFormat = dateFormat
        return formatter
    }
}
