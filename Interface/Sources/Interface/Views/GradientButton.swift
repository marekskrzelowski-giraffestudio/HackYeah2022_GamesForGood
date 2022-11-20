import SwiftUI
import Content

struct GradientButton: View {
    let title: String
    let colors: [Color]
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            Text(Content.copy(title))
                .font(.system(size: 14, weight: .semibold))
        }
        .frame(height: 56)
        .frame(maxWidth: .infinity)
        .background(
            LinearGradient(
                colors: colors,
                startPoint: .topLeading,
                endPoint: .bottomTrailing
            )
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}
