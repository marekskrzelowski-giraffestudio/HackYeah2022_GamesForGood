import SwiftUI
import Content

struct ChoiceModalView: View {
    @StateObject var viewModel: ChoiceModalViewModel

    var body: some View {
        ZStack {
            VStack(spacing: 0) {
                Text(viewModel.title)
                    .font(.system(size: 17, weight: .semibold))
                    .foregroundColor(Content.color(.blackWhite))
                    .padding(.top, 32)
                    .padding(.bottom, 8)
                    .padding(.horizontal, 20)
                Text(viewModel.message)
                    .font(.system(size: 16, weight: .regular))
                    .foregroundColor(Content.color(.blackLight))
                    .padding(.bottom, 32)
                    .padding(.horizontal, 20)
                    .multilineTextAlignment(.center)
                Color.black
                    .frame(maxWidth: .infinity, maxHeight: 1)
                HStack(alignment: .center, spacing: 0) {
                    Button(
                        action: { viewModel.cancel() },
                        label: {
                            Text(Content.copy("generic.cancel"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Content.color(.blackWhite))
                                .frame(maxWidth: .infinity, maxHeight: 48)
                        }
                    )
                    Color.black
                        .frame(maxWidth: 1, maxHeight: 48)
                    Button(
                        action: viewModel.confirm,
                        label: {
                            Text(Content.copy("generic.delete"))
                                .font(.system(size: 14, weight: .semibold))
                                .foregroundColor(Content.color(.blackWhite))
                                .frame(maxWidth: .infinity, maxHeight: 48)
                        }
                    )
                }
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
