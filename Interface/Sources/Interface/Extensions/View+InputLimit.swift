import SwiftUI

extension View {
    func inputLimit(value: Binding<String>, length: Int) -> some View {
        modifier(InputLimitModifier(value: value, length: length))
    }
}

private struct InputLimitModifier: ViewModifier {
    @Binding var value: String
    let length: Int

    func body(content: Content) -> some View {
        content
            .onChange(of: value) {
                value = String($0.prefix(length))
            }
    }
}
