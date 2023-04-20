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

extension View {
    func hydrogenReporter() -> some View {
        return self.modifier(HydrogenReporterModifier())
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
