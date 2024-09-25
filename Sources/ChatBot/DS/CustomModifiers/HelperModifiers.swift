//
//  File.swift
//  
//
//  Created by Appscrip 3Embed on 21/09/24.
//

import SwiftUI

public func getButtonOverlay(isDashed: Bool = false, borderColor: Color = .gray, backgroundColor: Color = .clear, radius: CGFloat = 25) -> some View {
    Group {
        if #available(iOS 17.0, *) {
            RoundedRectangle(cornerRadius: 25)
                .stroke(
                    borderColor,
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: isDashed ? [5, 3] : []
                    )
                )
                .background(backgroundColor)
        } else {
            RoundedRectangle(cornerRadius: 25.0)
                .stroke(
                    borderColor,
                    style: StrokeStyle(
                        lineWidth: 1,
                        dash: isDashed ? [5, 3] : []
                    )
                )
        }
    }
}
