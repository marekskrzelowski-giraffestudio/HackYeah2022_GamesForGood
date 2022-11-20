import SwiftUI
import Content
import Introspect
import Combine

enum TabbarPresentable: Presentable, CaseIterable, Identifiable {
    case learn, board, profile

    @ViewBuilder func view(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) -> some View {
        switch self {
        case .learn:
            NavigationCoordinatorView(
                coordinator: navigation ?? .init(
                    dependencies: dependencies,
                    tabbar: tabbar,
                    modal: modal,
                    root: .learn
                )
            )
        case .board:
            NavigationCoordinatorView(
                coordinator: navigation ?? .init(
                    dependencies: dependencies,
                    tabbar: tabbar,
                    modal: modal,
                    root: .board
                )
            )
        case .profile:
            NavigationCoordinatorView(
                coordinator: navigation ?? .init(
                    dependencies: dependencies,
                    tabbar: tabbar,
                    modal: modal,
                    root: .profile
                )
            )
        }
    }

    var id: Self { self }
}

@MainActor final class TabbarCoordinator: ObservableObject {
    @Published var presentable: TabbarPresentable
    @Published var tabbarVisible: Bool = true

    private let dependencies: Dependencies
    private let modal: ModalCoordinator?

    private lazy var learnCoordinator: NavigationCoordinator = .init(
        dependencies: dependencies, tabbar: self, modal: modal, root: .learn
    )

    private lazy var profileCoordinator: NavigationCoordinator = .init(
        dependencies: dependencies, tabbar: self, modal: modal, root: .profile
    )

    private var cancellables: [AnyCancellable] = []

    init(
        dependencies: Dependencies,
        modal: ModalCoordinator,
        presentable: TabbarPresentable
    ) {
        self.dependencies = dependencies
        self.modal = modal
        self.presentable = presentable
        setup()
    }

    func set(_ presentable: TabbarPresentable) {
        self.presentable = presentable
    }

    private func setup() {
        $presentable
            .scan((previous: nil, current: presentable)) { previousPair, current in
                (previous: previousPair.current, current: current)
            }
            .filter { $0.previous == $0.current }
            .map(\.current)
            .sink { [weak self] presentable in
                switch presentable {
                case .learn: self?.learnCoordinator.popToRoot()
                case .board: break
                case .profile: self?.profileCoordinator.popToRoot()
                }
            }
            .store(in: &cancellables)
    }

    private func navigationCoordinator(for presentable: TabbarPresentable) -> NavigationCoordinator? {
        switch presentable {
        case .learn: return learnCoordinator
        case .board: return nil
        case .profile: return profileCoordinator
        }
    }

    private func tabItem(for presentable: TabbarPresentable) -> some View {
        switch presentable {
        case .learn:
            return VStack(spacing: 0) {
                Content.image(.lamp)
                Text("Learn")
            }
        case .board:
            return VStack(spacing: 0) {
                Content.image(.chart)
                Text("Board")
            }
        case .profile:
            return VStack(spacing: 0) {
                Content.image(.profile)
                Text("Profile")
            }
        }
    }

    fileprivate func view(for presentable: TabbarPresentable, bottomInset: CGFloat) -> some View {
        ZStack {
            presentable
                .view(
                    dependencies: dependencies,
                    navigation: navigationCoordinator(for: presentable),
                    tabbar: self,
                    modal: modal
                )
                .padding(.bottom, tabbarVisible ? bottomInset : 0)
        }
        .tabItem { tabItem(for: presentable) }
        .edgesIgnoringSafeArea(.vertical)
        .tag(presentable)
    }
}

struct TabbarCoordinatorView: View {
    @StateObject var coordinator: TabbarCoordinator
    @State var tabBarControllerFrame: CGRect = .zero
    @State var tabBarFrame: CGRect = .zero

    var body: some View {
        TabView(selection: $coordinator.presentable) {
            ForEach(TabbarPresentable.allCases) { presentable in
                coordinator.view(for: presentable, bottomInset: tabBarFrame.height)
            }
        }
        .introspectTabBarController { controller in
            let appearance = controller.tabBar.standardAppearance
            appearance.configureWithDefaultBackground()
            appearance.backgroundColor = .init(Content.color(.blackWhite))
            controller.tabBar.scrollEdgeAppearance = appearance
            if !controller.tabBar.isHidden {
                tabBarControllerFrame = controller.view.frame
            }
            controller.tabBar.isHidden = !coordinator.tabbarVisible
            if controller.tabBar.isHidden {
                controller.view.frame = .init(
                    origin: .zero,
                    size: .init(
                        width: tabBarControllerFrame.width,
                        height: tabBarControllerFrame.height + controller.tabBar.frame.height
                    )
                )
            } else {
                controller.view.frame = tabBarControllerFrame
            }
            tabBarFrame = controller.tabBar.frame
            controller.tabBar.unselectedItemTintColor = .init(Content.color(.blackBlack))
            controller.tabBar.tintColor = .init(Content.color(.accentSecond))
        }
    }
}
