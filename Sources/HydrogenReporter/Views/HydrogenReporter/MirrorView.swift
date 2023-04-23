//
//  MirrorView.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

struct MirrorView: View {
    let mirror: Mirror
    let reflectedVariables: [(label: Optional<String>, value: Any)]
    
    init(mirror: Mirror) {
        self.mirror = mirror
        self.reflectedVariables = Array(mirror.children)
    }
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading) {
                ForEach(reflectedVariables, id: \.label) { variable in
                    buildValueLabel(label: variable.label, value: variable.value)
                }
                Spacer()
            }
        }
    }
    
    @ViewBuilder
    func buildValueLabel(label: Optional<String>, value: Any) -> some View {
        if let value = value as? Debuggable {
            RowView(label: "\(label ?? "No Label") =", data: value.swiftyDebugDescription)
        } else {
            RowView(label: "\(label ?? "No Label") =", data: "Not Debuggable")

        }
    }
}

struct MirrorView_Previews: PreviewProvider {
    static var previews: some View {
        MirrorView(mirror: Mirror(reflecting: self))
    }
}
