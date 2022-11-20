import SwiftUI
import Content

struct PrimaryButton: View {
    let text: String
    let height: CGFloat
    let fontSize: CGFloat
    let color: Color
    let action: () -> Void

    init(
        text: String = "",
        height: CGFloat = 50,
        fontSize: CGFloat = 17,
        color: Color = Content.color(.accentNormal),
        action: @escaping () -> Void
    ) {
        self.text = text
        self.height = height
        self.fontSize = fontSize
        self.color = color
        self.action = action
    }

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 0) {
                Text(text)
                    .font(.custom("Rubik-Bold", size: 17))
                    .foregroundColor(Content.color(.blackWhite))
                    .frame(height: height)
                    .frame(maxWidth: .infinity)
            }
        }
        .frame(height: height)
        .tint(color)
        .clipShape(Capsule())
        .buttonStyle(.borderedProminent)
    }
}

struct ActionButton: View {
    let action: () -> Void

    var body: some View {
        Button(action: action) {
            HStack(alignment: .center, spacing: 0) {
                Text("Działaj")
                    .font(.custom("Rubik-Bold", size: 16))
                    .foregroundColor(Content.color(.accentNormal))
                    .frame(width: 85, height: 39)
                Content.image(.arrowright)
            }
        }
        .frame(width: 115, height: 39)
        .foregroundColor(Content.color(.blackWhite))
        .clipShape(Capsule())
        .buttonStyle(.borderedProminent)
    }
}

