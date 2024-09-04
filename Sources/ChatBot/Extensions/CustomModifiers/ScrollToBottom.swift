import SwiftUI
import Combine

struct ScrollToBottomModifier<T: Equatable>: ViewModifier {
    let value: T
    let isFocused: Bool
    let bottomId: Namespace.ID
    
    @Binding var scrollProxy: ScrollViewProxy?
    @State private var cancellables = Set<AnyCancellable>()
    
    func body(content: Content) -> some View {
        content
            .onAppear {
                setupScrolling()
            }
    }
    
    private func setupScrolling() {
        if scrollProxy == nil {
            DispatchQueue.main.async {
                withAnimation(.easeInOut) {
                    scrollProxy?.scrollTo(bottomId, anchor: .bottom)
                }
            }
        }
        
        Just(value)
            .removeDuplicates()
            .sink { _ in
                withAnimation(.easeInOut) {
                    scrollProxy?.scrollTo(bottomId, anchor: .bottom)
                }
            }
            .store(in: &cancellables)
        
        Just(isFocused)
            .removeDuplicates()
            .sink { newValue in
                if newValue {
                    withAnimation(.easeInOut) {
                        scrollProxy?.scrollTo(bottomId, anchor: .bottom)
                    }
                }
            }
            .store(in: &cancellables)
    }
}

extension View {
    func scrollToBottom<T: Equatable>(
        value: T,
        isFocused: Bool,
        bottomId: Namespace.ID,
        proxy: Binding<ScrollViewProxy?>
    ) -> some View {
        self.modifier(ScrollToBottomModifier(
            value: value,
            isFocused: isFocused,
            bottomId: bottomId,
            scrollProxy: proxy
        ))
    }
}
