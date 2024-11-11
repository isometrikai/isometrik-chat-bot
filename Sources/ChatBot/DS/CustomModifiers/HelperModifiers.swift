
import SwiftUI

public func getButtonOverlay(isDashed: Bool = false, borderColor: Color = .gray, backgroundColor: Color = .clear, radius: CGFloat = 25) -> some View {
    Group {
        RoundedRectangle(cornerRadius: 25)
            .stroke(
                borderColor,
                style: StrokeStyle(
                    lineWidth: 1,
                    dash: isDashed ? [5, 3] : []
                )
            )
            .background(
                Rectangle()
                    .fill(backgroundColor)
                    .cornerRadius(25)
            )
    }
}
