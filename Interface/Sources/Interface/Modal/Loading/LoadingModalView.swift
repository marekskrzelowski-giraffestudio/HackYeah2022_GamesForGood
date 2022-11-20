import SwiftUI
import Content

struct LoadingModalView: View {
    @StateObject var viewModel: LoadingModalViewModel

    var body: some View {
        ZStack {
            Image(systemName: "circle")
                .resizable()
                .frame(width: 44, height: 44)
                .foregroundColor(Content.color(.blackWhite))
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Content.color(.blackBlack).opacity(0.3))
        .edgesIgnoringSafeArea(.all)
    }
}
