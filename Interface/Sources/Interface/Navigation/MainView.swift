import SwiftUI
import Content

public struct MainView: View {
    @StateObject var viewModel: MainViewModel = .init()

    public var body: some View {
        ZStack {
            if viewModel.logged {
                TabbarCoordinatorView(coordinator: viewModel.tabbar)
                    .accentColor(Content.color(.blackWhite))
                    .blur(radius: viewModel.blur ? 3 : 0)
                    .background(Content.color(.blackBlack))
                    .edgesIgnoringSafeArea(.all)
            } else {
                NavigationCoordinatorView(coordinator: viewModel.onboarding)
                
            }
            ModalCoordinatorView(coordinator: viewModel.modal)
        }
        .ignoresSafeArea()
    }

    public init() { }
}
