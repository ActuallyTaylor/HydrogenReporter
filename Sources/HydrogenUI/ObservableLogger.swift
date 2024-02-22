//
//  File.swift
//  
//
//  Created by Taylor Lineman on 2/21/24.
//

import Foundation
import HydrogenReporter

class ObservableLogger: ObservableObject {
    
    @Published public var logs: [Logger.LogItem] = []

    @Published public var consoleOutput: String = ""
    @Published public var stdout: String = ""
    @Published public var stderr: String = ""

    var observers: [NSKeyValueObservation] = []
    
    public static let shared: ObservableLogger = .init()
    
    private init() {
        let consoleOutputObserver = Logger.shared.observe(\.consoleOutput) { Logger, observedChange in
            self.consoleOutput = Logger.consoleOutput
        }
        let stdoutObserver = Logger.shared.observe(\.stdout, options: [.old, .new]) { Logger, observedChange in
            self.consoleOutput = Logger.consoleOutput
        }
        let stderrObserver = Logger.shared.observe(\.stderr, options: [.old, .new]) { Logger, observedChange in
            self.consoleOutput = Logger.consoleOutput
        }
        let logObserver = Logger.shared.observe(\.logCounter, options: [.old, .new]) { Logger, observedChange in
            self.logs = Logger.logs
        }

        observers.append(contentsOf: [consoleOutputObserver, stdoutObserver, stderrObserver, logObserver])
    }
}
