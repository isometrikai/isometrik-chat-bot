//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 21/09/24.
//

import SwiftUI

public func getButtonOverlay(isDashed: Bool = false, color: Color = .gray) -> some View {
    Group {
        if #available(iOS 17.0, *) {
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: isDashed ? [5, 3] : []
                    )
                )
                .background(Color.clear)
        } else {
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(
                    color,
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: isDashed ? [5, 3] : []
                    )
                )
        }
    }
}
