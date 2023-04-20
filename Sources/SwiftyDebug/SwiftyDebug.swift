//
//  SwiftyDebug.swift
//  
//
//  Created by Taylor Lineman on 4/19/23.
//

import SwiftUI

class Test: ObservableObject, Debuggable {
    var swiftyDebugDescription: String = "Hello"
    
    @Published var test: String = "Hello Publisher"
}

struct TestView: View {
    @StateObject var test: Test = Test()
    @State var string: String = "Hello World"

    var body: some View {
        NavigationView {
            VStack {
                TextField("Text", text: $string)
                    .textFieldStyle(.roundedBorder)
                Button("Log Fatal") {
                    LOG("Fatal Error!!!", level: .fatal)
                }
                Button("Log Error") {
                    LOG("You just broke everything", level: .error)
                }
                Button("Log Warning") {
                    LOG("You should not have done that", level: .warn)
                }
                Button("Log Info") {
                    LOG("Chilling", level: .info)
                }
                Button("Log Success") {
                    LOG("That worked!", level: .success)
                }
                Button("Log Working") {
                    LOG("Working on something...", level: .working)
                }
                Button("Log Debug") {
                    LOG("Print Debugging is where it is at", level: .debug)
                }
            }
        }
        .swiftyDebug()
        .debuggable(self, id: "Main View")
        .debuggable(test, id: "Test Publisher")
        .customDebuggableView(id: "Custom View", view: customView)
    }
    
    var customView: some View {
        VStack {
            Text("Hello World!")
            Text("Some State \(string)")
        }
    }
}

struct SwiftyDebug_Previews: PreviewProvider {
    static var previews: some View {
        TestView()
    }
}

struct SwiftyConsole: View {
    @StateObject var logger: Logger = .shared
    
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
                }
            }
            .frame(maxHeight: 100)
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
                Text("\(Logger.LogLevel.fatal.emoji()) \(totalFatalLogs)")
                Text("\(Logger.LogLevel.error.emoji()) \(totalErrorLogs)")
                Text("\(Logger.LogLevel.warn.emoji()) \(totalWarnLogs)")
                Text("\(Logger.LogLevel.info.emoji()) \(totalInfoLogs)")
                Text("\(Logger.LogLevel.success.emoji()) \(totalSuccessLogs)")
                Text("\(Logger.LogLevel.working.emoji()) \(totalWorkingLogs)")
                Text("\(Logger.LogLevel.debug.emoji()) \(totalDebugLogs)")
            }
            .font(.caption2)
            
            let newTotalLogs = totalLogs == 0 ? 1 : totalLogs
            Text("Percents")
                .font(.caption)
                .bold()
            HStack {
                Text("\(Logger.LogLevel.fatal.emoji()) \(getPercent(value: totalFatalLogs, divisor: newTotalLogs))")
                Text("\(Logger.LogLevel.error.emoji()) \(getPercent(value: totalErrorLogs, divisor: newTotalLogs))")
                Text("\(Logger.LogLevel.warn.emoji()) \(getPercent(value: totalWarnLogs, divisor: newTotalLogs))")
                Text("\(Logger.LogLevel.info.emoji()) \(getPercent(value: totalInfoLogs, divisor: newTotalLogs))")
                Text("\(Logger.LogLevel.success.emoji()) \(getPercent(value: totalSuccessLogs, divisor: newTotalLogs))")
                Text("\(Logger.LogLevel.working.emoji()) \(getPercent(value: totalWorkingLogs, divisor: newTotalLogs))")
                Text("\(Logger.LogLevel.debug.emoji()) \(getPercent(value: totalDebugLogs, divisor: newTotalLogs))")
            }
            .font(.caption2)
        }
    }
    
    func getPercent(value: Int, divisor: Int) -> String {
        return String(format: "%.2f", (Double(value) / Double(divisor)))
    }
}

struct SwiftyMirror: View {
    let mirror: Mirror
    let reflectedVariables: [(label: Optional<String>, value: Any)]
    
    init(mirror: Mirror) {
        self.mirror = mirror
        self.reflectedVariables = Array(mirror.children)
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            ForEach(reflectedVariables, id: \.label) { variable in
                buildValueLabel(label: variable.label, value: variable.value)
            }
        }
    }
    
    @ViewBuilder
    func buildValueLabel(label: Optional<String>, value: Any) -> some View {
        HStack {
            Text("\(label ?? "No Label") =")
                .bold()
            
            if let value = value as? Debuggable {
                Text(value.swiftyDebugDescription)
            } else {
                Text("Not Debuggable")
            }
        }
    }
}

// MARK: Swifty Debug
struct SwiftyDebug: View {
    @StateObject var debugHandler: DebugHandler = .shared
    
    var body: some View {
        GeometryReader { reader in
            VStack(alignment: .leading, spacing: 10) {
                ZStack {
                    HStack {
                        Button {
                            debugHandler.previousTab()
                        } label: {
                            Image(systemName: "chevron.left")
                            Text("Previous")
                        }
                        .disabled(!debugHandler.hasPreviousTab())
                        Spacer()
                        Button {
                            debugHandler.nextTab()
                        } label: {
                            Text("Next")
                            Image(systemName: "chevron.right")
                        }
                        .disabled(!debugHandler.hasNextTab())
                    }
                    Text(debugHandler.debugTabs[debugHandler.currentTabIndex].title)
                        .font(.headline)
                }
                switch debugHandler.debugTabs[debugHandler.currentTabIndex] {
                case .console:
                    SwiftyConsole()
                case .mirror(_ , let mirror):
                    SwiftyMirror(mirror: mirror)
                case .customView(_, let view):
                    view
                }
            }
            .padding(10)
            .addBorder(Color.accentColor.opacity(0.5), width: 1, cornerRadius: 7)
            .background(.ultraThickMaterial)
            .padding(10)
        }
    }
}

struct SwiftDebugModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(
            SwiftyDebug()
        )
    }
}

extension View {
    func swiftyDebug() -> some View {
        return self.modifier(SwiftDebugModifier())
    }
    
    func debuggable(_ target: Any, id: String) -> some View {
        DebugHandler.shared.registerMirror(id: id, mirror: Mirror(reflecting: target))
        return self
    }
    
    func customDebuggableView(id: String, view: some View) -> some View {
        DebugHandler.shared.registerCustomDebugView(id: id, view: AnyView(view))
        return self
    }
}
