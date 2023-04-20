//
//  RowView.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

struct RowView: View {
    var label: String
    var data: String
    
    var body: some View {
        HStack {
            Text(label)
                .bold()
            Spacer()
            Text(data)
        }
    }
}

struct RowView_Previews: PreviewProvider {
    static var previews: some View {
        RowView(label: "Test Label", data: "Test Data")
    }
}
