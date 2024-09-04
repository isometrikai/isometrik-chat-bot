
import SwiftUI
import Combine

extension View {
    @ViewBuilder
    func onChangeCompat<Value: Equatable>(of value: Value?, perform action: @escaping (Value) -> Void) -> some View {
        if #available(iOS 17.0, *) {
            self.onChange(of: value!, perform: action)
        } else {
            self.onReceive(Just(value).compactMap { $0 }.dropFirst()) { newValue in
                action(newValue)
            }
        }
    }
}
