//
//  StatisticsView.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

struct StatisticsView: View {
    
    var body: some View {
        VStack {
            RowView(label: "Device Name", data: UIDevice.modelName)
            RowView(label: "CPU Load", data: "\(UIDevice.hostCPULoadInfo())")
        }
    }
}

struct StatisticsView_Previews: PreviewProvider {
    static var previews: some View {
        StatisticsView()
    }
}
