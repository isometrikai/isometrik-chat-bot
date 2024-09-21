//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 21/09/24.
//

import SwiftUI

public struct ContentMarginsModifier: ViewModifier {
    var top: CGFloat
    var bottom: CGFloat
    var leading: CGFloat
    var trailing: CGFloat

    public init(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) {
        self.top = top
        self.bottom = bottom
        self.leading = leading
        self.trailing = trailing
    }

    public func body(content: Content) -> some View {
        if #available(iOS 17.0, *) {
            content
                .contentMargins(.top, top, for: .scrollContent)
                .contentMargins(.bottom, bottom, for: .scrollContent)
                .contentMargins(.leading, leading, for: .scrollContent)
                .contentMargins(.trailing, trailing, for: .scrollContent)
        } else {
            content
                .padding(.top, top)
                .padding(.bottom, bottom)
                .padding(.leading, leading)
                .padding(.trailing, trailing)
        }
    }
}

extension View {
    public func customContentMargins(top: CGFloat = 0, bottom: CGFloat = 0, leading: CGFloat = 0, trailing: CGFloat = 0) -> some View {
        self.modifier(ContentMarginsModifier(top: top, bottom: bottom, leading: leading, trailing: trailing))
    }
}
