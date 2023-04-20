//
//  RoundedBorder.swift
//  
//
//  Created by Taylor Lineman on 4/20/23.
//

import SwiftUI

/// https://swiftui-lab.com/view-extensions-for-better-code-readability/
extension View {
    public func addBorder<S>(_ content: S, width: CGFloat = 1, cornerRadius: CGFloat) -> some View where S : ShapeStyle {
        let roundedRect = RoundedRectangle(cornerRadius: cornerRadius)
        return clipShape(roundedRect)
             .overlay(roundedRect.strokeBorder(content, lineWidth: width))
    }
}
