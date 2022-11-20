import SwiftUI
import Content

struct UnavailableModalView: View {
    @StateObject var viewModel: UnavailableModalViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(Content.copy("popup.unavailable.title"))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Content.color(.blackWhite))
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 20)
                Text(Content.copy("popup.unavailable.subtitle"))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Content.color(.blackLight))
                    .padding(.bottom, 32)
                Color.black
                    .frame(maxWidth: .infinity, maxHeight: 1)
                Text(Content.copy("generic.confirm"))
                    .font(.system(size: 14, weight: .semibold))
                    .foregroundColor(Content.color(.blackWhite))
                    .frame(maxWidth: .infinity, maxHeight: 48)
            }
            .background(Content.color(.blackGrey).opacity(0.7))
            .cornerRadius(8)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Content.color(.blackBlack).opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}
