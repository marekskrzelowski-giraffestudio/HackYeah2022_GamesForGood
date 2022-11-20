import SwiftUI
import Content

struct CheckBoxView: View {
    @Binding var selected: Bool

    var body: some View {
        ZStack {
            if selected {
                Circle()
                    .foregroundColor(Content.color(selected ? .accentNormal : .blackDarkGrey))
                Content.image(.lamp)
                    .resizable()
                    .foregroundColor(Content.color(.blackWhite))
                    .frame(width: 15, height: 15)
            } else {
                Circle()
                    .stroke(Content.color(selected ? .blackDarkGrey : .blackGrey), lineWidth: 1)
            }
        }
        .frame(width: 28, height: 28)
    }
}
