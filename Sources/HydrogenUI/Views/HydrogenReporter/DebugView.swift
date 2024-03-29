//
//  SwiftUIView.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI
import HydrogenReporter

// MARK: Swifty Debug
@available(macOS 12.0, *)
struct DebugView: View {
    @StateObject var debugHandler: DebugHandler = .shared
    @StateObject var logger: Logger = .shared

    @State var height: CGFloat = 200 {
        didSet {
            if height < 0 {
                height = 0
            }
        }
    }
    
    @State var startedDragging: Date? = nil
    @State var buttonPosition: CGPoint? = nil
    
    @State var showingReporter: Bool = false
    @State var showingSelf: Bool = true
    
    var body: some View {
        if Config.isDebug && showingSelf {
            internalBody
        } else {
            EmptyView()
        }
    }
    
    var internalBody: some View {
        GeometryReader { reader in
            ZStack(alignment: .bottomTrailing) {
                if showingReporter {
                    VStack(alignment: .leading, spacing: 10) {
                        ZStack {
                            HStack {
                                Button {
                                    debugHandler.previousTab()
                                } label: {
                                    Image(systemName: "chevron.left")
                                    Text(debugHandler.getPreviousTab()?.title ?? "None")
                                }
                                .disabled(!debugHandler.hasPreviousTab())
                                Spacer()
                                Button {
                                    debugHandler.nextTab()
                                } label: {
                                    Text(debugHandler.getNextTab()?.title ?? "None")
                                    Image(systemName: "chevron.right")
                                }
                                .disabled(!debugHandler.hasNextTab())
                            }
                            Text(debugHandler.debugTabs[debugHandler.currentTabIndex].title)
                                .font(.headline)
                        }
                        .zIndex(10)
                        Group {
                            switch debugHandler.debugTabs[debugHandler.currentTabIndex] {
                            case .logger:
                                LoggerView()
                                    .environmentObject(logger)
                            case .mirror(_ , let mirror):
                                MirrorView(mirror: mirror)
                            case .customView(_, let view):
                                view
                            case .statistics:
                                #if canImport(UIKit)
                                StatisticsView()
                                #else
                                Text("Statistics View Not Available on macOS")
                                #endif
                            case .console:
                                Console()
                                    .environmentObject(logger)
                            }
                        }
                        .frame(height: height)
                        .zIndex(5)
                        dragBar()
                            .zIndex(10)
                    }
                    .padding(10)
                    .addBorder(Color.accentColor.opacity(0.5), width: 1, cornerRadius: 7)
                    .background(.ultraThinMaterial)
                    .cornerRadius(7)
                    .padding(10)
                }
            }
            Menu {
                Button {
                    showingReporter.toggle()
                } label: {
                    Label("\(showingReporter ? "Close" : "Open") Reporter", systemImage: "exclamationmark.bubble.fill")
                }

                Button {
                    do {
                        #if canImport(UIKit)
                        try shareLog()
                        #endif
                    } catch {
                        LOG("Failed to share log \(error)", level: .error)
                    }
                } label: {
                    Label("Export Console Logs", systemImage: "square.and.arrow.up.trianglebadge.exclamationmark")
                }
                
                Button(role: .destructive) {
                    showingSelf.toggle()
                } label: {
                    Label("Close Hydrogen Menu", systemImage: "xmark")
                }

            } label: {
                Label("Menu", systemImage: "menucard.fill")
                    .font(.title2)
                    .frame(width: 25, height: 25)
                    .labelStyle(.iconOnly)
                    .padding(10)
                    .background(.ultraThickMaterial)
                    .cornerRadius(10)
                    .padding()
            }
            .position(buttonPosition ?? .zero)
            .gesture(menuDragGesture(reader: reader))
            .onAppear {
                if buttonPosition == nil {
                    buttonPosition = CGPoint(x: reader.size.width - 45, y: reader.size.height - 45)
                }
            }
        }
    }
    
    @ViewBuilder
    func dragBar() -> some View {
        HStack {
            Spacer()
            RoundedRectangle(cornerRadius: 30)
                .foregroundColor(.secondary)
                .frame(width: 50, height: 5)
            Spacer()
        }
        .gesture(heightDragGesture())
    }

    
    func heightDragGesture() -> some Gesture {
        DragGesture()
            .onChanged { value in
                height += value.translation.height
            }
    }
    
    
    func menuDragGesture(reader: GeometryProxy) -> some Gesture {
        DragGesture()
            .onChanged { value in
                buttonPosition = value.location
//                prediction = value.predictedEndLocation

                if let bp = buttonPosition {
                    if bp.y < 0 {
                        buttonPosition?.y = 0
                    }
                    if bp.x < 0 {
                        buttonPosition?.x = 0
                    }
                    if bp.y >= reader.size.height - 25 {
                        buttonPosition?.y = reader.size.height - 25
                    }
                    if bp.x >= reader.size.width - 25 {
                        buttonPosition?.x = reader.size.width - 25
                    }
                }
                
                if startedDragging == nil {
                    startedDragging = .now
                }
            }
            .onEnded { value in
                var alteredEndPosition = value.predictedEndLocation
                
                if alteredEndPosition.y < 10 {
                    alteredEndPosition.y = 10
                }
                if alteredEndPosition.x < 35 {
                    alteredEndPosition.x = 35
                }
                if alteredEndPosition.y >= reader.size.height - 35 {
                    alteredEndPosition.y = reader.size.height - 35
                }
                if alteredEndPosition.x >= reader.size.width - 35 {
                    alteredEndPosition.x = reader.size.width - 35
                }
                
                withAnimation(.easeOut(duration: 0.7)) {
                    buttonPosition = alteredEndPosition
                }
            }
    }

    #if canImport(UIKit)
    @discardableResult
    func shareLog() throws -> Bool {
        guard let source = UIApplication.shared.keyWindow?.rootViewController else {
            return false
        }
        
        let logFile = try Logger.shared.dumpToFile()
        
        let vc = UIActivityViewController(
            activityItems: [logFile],
            applicationActivities: nil
        )
        

        vc.popoverPresentationController?.sourceView = source.view
        source.present(vc, animated: true)
        return true
    }
    #endif

}

@available(macOS 12.0, *)
struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
