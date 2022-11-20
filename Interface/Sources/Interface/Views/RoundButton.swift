import SwiftUI
import Content

struct RoundButton: View {
    let title: String
    let image: Image
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 12) {
                ZStack {
                    Circle()
                        .foregroundColor(Content.color(.blackSemidark))
                    image
                        .padding(.all, 10)
                }
                Text(Content.copy(title))
                    .font(.system(size: 14, weight: .semibold))
                    .fixedSize()
            }
            .frame(height: 40)
            .frame(maxWidth: .infinity)
        }
    }
}
