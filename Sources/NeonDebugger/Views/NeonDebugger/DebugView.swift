//
//  SwiftUIView.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

// MARK: Swifty Debug
struct DebugView: View {
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
                    Console()
                case .mirror(_ , let mirror):
                    MirrorView(mirror: mirror)
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


struct DebugView_Previews: PreviewProvider {
    static var previews: some View {
        DebugView()
    }
}
