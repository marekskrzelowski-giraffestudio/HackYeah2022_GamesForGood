import SwiftUI
import Content

struct ErrorModalView: View {
    @StateObject var viewModel: ErrorModalViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(Content.copy("Error"))
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Content.color(.blackWhite))
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 20)
                Text(Content.copy(viewModel.message ?? Content.copy("Unknown error")))
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Content.color(.blackLight))
                    .padding(.bottom, 32)
                Color.black
                    .frame(maxWidth: .infinity, maxHeight: 1)
                    .opacity(0.3)
                Button(
                    action: { viewModel.dismiss() },
                    label: {
                        Text(Content.copy("Confirm"))
                            .font(.system(size: 14, weight: .semibold))
                            .foregroundColor(Content.color(.blackWhite))
                            .frame(maxWidth: .infinity, maxHeight: 48)
                    }
                )
            }
            .background(Content.color(.blackGrey).opacity(0.9))
            .cornerRadius(8)
            .padding(.horizontal, 20)
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Content.color(.blackBlack).opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}
