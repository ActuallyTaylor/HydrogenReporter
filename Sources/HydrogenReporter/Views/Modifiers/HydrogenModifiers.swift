//
//  HydrogenModifiers.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

struct HydrogenReporterModifier: ViewModifier {
    func body(content: Content) -> some View {
        content.overlay(DebugView())
    }
}

public extension View {
    func hydrogenReporter() -> some View {
        return self.modifier(HydrogenReporterModifier())
    }
    
    @MainActor func debuggable(_ target: Any, id: String) -> some View {
        DebugHandler.shared.registerMirror(id: id, mirror: Mirror(reflecting: target))
        return self
    }
    
    @MainActor func customDebuggableView(_ target: some View, id: String) -> some View {
        DebugHandler.shared.registerCustomDebugView(id: id, view: AnyView(target))
        return self
    }
}
