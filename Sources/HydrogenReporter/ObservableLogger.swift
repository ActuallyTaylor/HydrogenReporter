//
//  File.swift
//  
//
//  Created by Taylor Lineman on 2/21/24.
//

import Foundation

public class ObservableLogger: ObservableObject {
    
    @Published public var logs: [Logger.LogItem] = []

    @Published public var consoleOutput: String = ""
    @Published public var stdout: String = ""
    @Published public var stderr: String = ""

    var observers: [NSKeyValueObservation] = []
    
    public init() {
        let consoleOutputObserver = Logger.shared.observe(\._consoleOutput) { Logger, observedChange in
            self.consoleOutput = Logger.consoleOutput
        }
        let stdoutObserver = Logger.shared.observe(\._stdout, options: [.old, .new]) { Logger, observedChange in
            self.consoleOutput = Logger.consoleOutput
        }
        let stderrObserver = Logger.shared.observe(\._stderr, options: [.old, .new]) { Logger, observedChange in
            self.consoleOutput = Logger.consoleOutput
        }
        let logObserver = Logger.shared.observe(\.logCounter, options: [.old, .new]) { Logger, observedChange in
            self.logs = Logger.logs
        }

        observers.append(contentsOf: [consoleOutputObserver, stdoutObserver, stderrObserver, logObserver])
    }
}
