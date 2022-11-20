import SwiftUI
import Core

enum NavigationPresentable: Presentable {
    case login
    case learn
    case board
    case profile
    case mission(Mission)

    @ViewBuilder func view(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) -> some View {
        switch self {
        case .login:
            LoginView(
                viewModel: .init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
            )
        case .learn:
            LearnView(
                viewModel: .init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
            )
        case .board:
            EmptyView()
        case .profile:
            ProfileView(
                viewModel: .init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
            )
        case let .mission(mission):
            MissionDetails(
                viewModel: .init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal, mission: mission)
            )
        }
    }
}

@MainActor final class NavigationCoordinator: ObservableObject {
    @Published private(set) var stack: [UIViewController] = []
    private let dependencies: Dependencies
    private let tabbar: TabbarCoordinator?
    private let modal: ModalCoordinator?

    init(
        dependencies: Dependencies,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?,
        root: NavigationPresentable
    ) {
        self.dependencies = dependencies
        self.tabbar = tabbar
        self.modal = modal
        push(root)
    }

    func push(_ presentable: NavigationPresentable) {
        let view = presentable
            .view(dependencies: dependencies, navigation: self, tabbar: tabbar, modal: modal)
            .navigationBarHidden(true)
        let host = UIHostingController(rootView: view)
        host.view.backgroundColor = .clear
        stack.append(host)
    }

    func pop() {
        stack.removeLast()
    }

    func popToRoot() {
        stack.removeLast(stack.count - 1)
    }

    fileprivate func view(for presentable: NavigationPresentable) -> some View {
        presentable.view(
            dependencies: dependencies,
            navigation: self,
            tabbar: tabbar,
            modal: modal
        )
    }
}

struct NavigationCoordinatorView: UIViewControllerRepresentable {
    typealias UIViewControllerType = UINavigationController
    @StateObject var coordinator: NavigationCoordinator

    func makeUIViewController(context: Context) -> UIViewControllerType {
        let viewController = UIViewControllerType()
        viewController.setNavigationBarHidden(true, animated: false)
        return viewController
    }

    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        uiViewController.setViewControllers(coordinator.stack, animated: false)
    }
}
