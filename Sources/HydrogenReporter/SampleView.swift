//
//  SampleView.swift
//  
//
//  Created by Taylor Lineman on 4/19/23.
//

import SwiftUI

class SampleViewModel: ObservableObject, Debuggable {
    var swiftyDebugDescription: String = "Hello"
    
    @Published var test: String = "Hello Publisher"
}

struct SampleView: View {
    @StateObject var viewModel: SampleViewModel = SampleViewModel()
    @State var string: String = "Hello World"

    var body: some View {
        NavigationView {
            VStack {
                TextField("Text", text: $string)
                    .textFieldStyle(.roundedBorder)
                
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
        .hydrogenReporter()
        .debuggable(self, id: "Main View")
        .debuggable(viewModel, id: "Model Publisher")
        .customDebuggableView(id: "Custom View", view: customView)
    }
    
    var customView: some View {
        VStack {
            Text("Hello World!")
            Text("Some State \(string)")
        }
    }
}

struct SampleView_Previews: PreviewProvider {
    static var previews: some View {
        SampleView()
    }
}
