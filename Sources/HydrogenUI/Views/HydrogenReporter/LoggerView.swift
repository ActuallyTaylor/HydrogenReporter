//
//  Console.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI
import HydrogenReporter

struct LoggerView: View {
    @EnvironmentObject var logger: Logger
    
    var body: some View {
        VStack(alignment: .leading, spacing: 5) {
            statsView()
            ScrollView {
                ScrollViewReader { reader in
                    LazyVStack(alignment: .leading, spacing: 5) {
                        ForEach(logger.logs) { log in
                            Text(log.description)
                                .id(log.id)
                        }
                    }
                    .onChange(of: logger.logs.count) { _ in
                        reader.scrollTo(logger.logs.last?.id)
                    }
                    .onAppear {
                        reader.scrollTo(logger.logs.last?.id)
                    }
                }
            }
        }
    }
    
    
    @ViewBuilder
    func statsView() -> some View {
        VStack(alignment: .leading) {
            let totalLogs = logger.logs.count
            let totalFatalLogs = logger.logs.filter({$0.level == .fatal}).count
            let totalErrorLogs = logger.logs.filter({$0.level == .error}).count
            let totalWarnLogs = logger.logs.filter({$0.level == .warn}).count
            let totalInfoLogs = logger.logs.filter({$0.level == .info}).count
            let totalSuccessLogs = logger.logs.filter({$0.level == .success}).count
            let totalWorkingLogs = logger.logs.filter({$0.level == .working}).count
            let totalDebugLogs = logger.logs.filter({$0.level == .debug}).count

            Text("Totals:")
                .font(.caption)
                .bold()
            HStack(alignment: .center) {
                Text("✨ \(totalLogs)")
                Text("\(LogLevel.fatal.emoji()) \(totalFatalLogs)")
                Text("\(LogLevel.error.emoji()) \(totalErrorLogs)")
                Text("\(LogLevel.warn.emoji()) \(totalWarnLogs)")
                Text("\(LogLevel.info.emoji()) \(totalInfoLogs)")
                Text("\(LogLevel.success.emoji()) \(totalSuccessLogs)")
                Text("\(LogLevel.working.emoji()) \(totalWorkingLogs)")
                Text("\(LogLevel.debug.emoji()) \(totalDebugLogs)")
            }
            .font(.caption2)
            
            let newTotalLogs = totalLogs == 0 ? 1 : totalLogs
            Text("Percents")
                .font(.caption)
                .bold()
            HStack {
                Text("\(LogLevel.fatal.emoji()) \(getPercent(value: totalFatalLogs, divisor: newTotalLogs))")
                Text("\(LogLevel.error.emoji()) \(getPercent(value: totalErrorLogs, divisor: newTotalLogs))")
                Text("\(LogLevel.warn.emoji()) \(getPercent(value: totalWarnLogs, divisor: newTotalLogs))")
                Text("\(LogLevel.info.emoji()) \(getPercent(value: totalInfoLogs, divisor: newTotalLogs))")
                Text("\(LogLevel.success.emoji()) \(getPercent(value: totalSuccessLogs, divisor: newTotalLogs))")
                Text("\(LogLevel.working.emoji()) \(getPercent(value: totalWorkingLogs, divisor: newTotalLogs))")
                Text("\(LogLevel.debug.emoji()) \(getPercent(value: totalDebugLogs, divisor: newTotalLogs))")
            }
            .font(.caption2)
        }
    }
    
    func getPercent(value: Int, divisor: Int) -> String {
        return String(format: "%.2f", (Double(value) / Double(divisor)))
    }
}


struct LoggerView_Previews: PreviewProvider {
    static var previews: some View {
        LoggerView()
    }
}
