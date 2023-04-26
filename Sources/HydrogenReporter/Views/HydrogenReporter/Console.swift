//
//  SwiftUIView.swift
//  
//
//  Created by Taylor Lineman on 4/23/23.
//

import SwiftUI

struct Console: View {
    enum OutputMode {
        case all
        case stderr
        case stdout
    }
    
    @EnvironmentObject var logger: Logger
    @State var outputMode: OutputMode = .stdout
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollViewReader { reader in
                ScrollView {
                    Group {
                        switch outputMode {
                        case .all:
                            Text(logger.consoleOutput)
                                .font(.system(size: 13, design: .monospaced))
                                .multilineTextAlignment(.leading)
                                .id(0)
                                .onChange(of: logger.consoleOutput) { newValue in
                                    reader.scrollTo(0, anchor: .bottom)
                                }
                        case .stderr:
                            Text(logger.stderr)
                                .font(.system(size: 13, design: .monospaced))
                                .multilineTextAlignment(.leading)
                                .id(0)
                                .onChange(of: logger.stderr) { newValue in
                                    reader.scrollTo(0, anchor: .bottom)
                                }
                        case .stdout:
                            Text(logger.stdout)
                                .font(.system(size: 13, design: .monospaced))
                                .multilineTextAlignment(.leading)
                                .id(0)
                                .onChange(of: logger.stdout) { newValue in
                                    reader.scrollTo(0, anchor: .bottom)
                                }
                        }
                    }
                    .onAppear {
                        reader.scrollTo(0, anchor: .bottom)
                    }
                    .onChange(of: outputMode) { newValue in
                        reader.scrollTo(0, anchor: .bottom)
                    }
                }
            }
            HStack {
                Picker("Output", selection: $outputMode) {
                    Text("All Output")
                        .tag(OutputMode.all)
                        .padding(0)
                    Text("Standard Output")
                        .tag(OutputMode.stdout)
                        .padding(0)
                    Text("Standard Error")
                        .tag(OutputMode.stderr)
                        .padding(0)
                }
                .pickerStyle(.menu)
                Spacer()
            }
        }
    }
}

struct Console_Previews: PreviewProvider {
    static var previews: some View {
        Console()
            .environmentObject(Logger.shared)
    }
}
