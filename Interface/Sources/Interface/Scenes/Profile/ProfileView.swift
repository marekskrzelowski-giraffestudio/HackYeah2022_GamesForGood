import SwiftUI
import Content

struct ProfileView: View {
    @StateObject var viewModel: ProfileViewModel

    var body: some View {
        VStack(spacing: 0) {
            Button("Logout") {
                viewModel.logout()
            }
            .frame( width: 100, height: 50)
        }
        .background(.red)
        .padding(.bottom, 10)
    }

}
