import SwiftUI

extension View {
    func onLoad(perform action: @escaping () -> Void) -> some View {
        modifier(OnLoadModifier(action: action))
    }
}

private struct OnLoadModifier: ViewModifier {
    @State private var didLoad = false
    let action: () -> Void

    func body(content: Content) -> some View {
        content.onAppear {
            if !didLoad {
                didLoad = true
                action()
            }
        }
    }
}
