//
//  SwiftUIView.swift
//  
//
//  Created by Taylor Lineman on 4/23/23.
//

import SwiftUI

struct Console: View {
    @EnvironmentObject var logger: Logger
    
    var body: some View {
        VStack {
            ScrollView {
                Text(logger.consoleOutput)
                    .font(.system(.body, design: .monospaced))
                    .multilineTextAlignment(.leading)
            }
        }
    }
}

struct Console_Previews: PreviewProvider {
    static var previews: some View {
        Console()
    }
}
