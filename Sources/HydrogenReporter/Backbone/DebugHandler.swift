//
//  DebugHandler.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import Foundation
import SwiftUI

@MainActor
public class DebugHandler: ObservableObject {
    enum DebugTab: Identifiable, Equatable {
        public var id: String { title }
        
        case logger
        case statistics
        case mirror(id: String, mirror: Mirror)
        case customView(id: String, view: AnyView)
        case console
        
        var title: String {
            switch self {
            case .logger:
                return "Logger"
            case .statistics:
                return "Statistics"
            case .mirror(let id, _):
                return id
            case .customView(let id, _):
                return id
            case .console:
                return "Console"
            }
        }
        
        static func == (lhs: DebugHandler.DebugTab, rhs: DebugHandler.DebugTab) -> Bool {
            return lhs.id == rhs.id
        }
    }
    
    @Published var debugTabs: [DebugTab] = [.statistics, .logger, .console]
    @Published var currentTabIndex: Int = 1
    
    public static let shared = DebugHandler()
    
    private init() { }
    
    func registerCustomDebugView(id: String, view: AnyView) {
        debugTabs.removeAll { tab in
            switch tab {
            case .customView(let tabID, _):
                return tabID == id
            default:
                return false
            }
        }
        
        debugTabs.append(.customView(id: id, view: view))
    }
    
    public func registerMirror(id: String, mirror: Mirror) {
        debugTabs.removeAll { tab in
            switch tab {
            case .mirror(let tabID, _):
                return tabID == id
            default:
                return false
            }
        }
        
        debugTabs.append(.mirror(id: id, mirror: mirror))
    }
    
    func hasPreviousTab() -> Bool {
        return currentTabIndex != 0
    }
    
    func getPreviousTab() -> DebugTab? {
        if hasPreviousTab() {
            return debugTabs[currentTabIndex - 1]
        } else {
            return nil
        }
    }
    
    func previousTab() {
        if currentTabIndex != 0 {
            currentTabIndex -= 1
        }
    }
    
    func hasNextTab() -> Bool {
        return currentTabIndex != debugTabs.count - 1
    }
    
    func getNextTab() -> DebugTab? {
        if hasNextTab() {
            return debugTabs[currentTabIndex + 1]
        } else {
            return nil
        }
    }
    
    func nextTab() {
        if currentTabIndex != debugTabs.count - 1  {
            currentTabIndex += 1
        }
    }
}
