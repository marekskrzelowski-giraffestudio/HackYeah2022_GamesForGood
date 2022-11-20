import SwiftUI

extension View {
    func onTapGesture<T>(performIfHandled action: ((T) -> Void)?, argument: T) -> some View {
        modifier(OnTapGestureIfHandledModifier(action: action, argument: argument))
    }
}

private struct OnTapGestureIfHandledModifier<T>: ViewModifier {
    let action: ((T) -> Void)?
    let argument: T

    func body(content: Content) -> some View {
        if let action = action {
            content.onTapGesture { action(argument) }
        } else {
            content
        }
    }
}
