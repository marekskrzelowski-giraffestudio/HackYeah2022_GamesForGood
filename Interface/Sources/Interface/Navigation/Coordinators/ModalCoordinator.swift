import SwiftUI
import Core

enum ModalPresentable: Presentable {
    case error(message: String?)
    case loading
    case unavailable
    case choice(title: String, message: String, confirm: () -> Void)

    @ViewBuilder func view(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) -> some View {
        switch self {
        case let .error(message):
            ErrorModalView(
                viewModel: .init(
                    dependencies: dependencies,
                    navigation: navigation,
                    tabbar: tabbar,
                    modal: modal,
                    message: message
                )
            )
        case .loading:
            LoadingModalView(
                viewModel: .init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
            )
        case .unavailable:
            UnavailableModalView(
                viewModel: .init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
            )
        case let .choice(title, message, confirm):
            ChoiceModalView(
                viewModel: .init(
                    dependencies: dependencies,
                    navigation: navigation,
                    tabbar: tabbar,
                    modal: modal,
                    title: title,
                    message: message,
                    confirm: confirm
                )
            )
        }
    }
}

@MainActor final class ModalCoordinator: ObservableObject {
    @Published var presentable: ModalPresentable?
    let dependencies: Dependencies

    init(dependencies: Dependencies) {
        self.dependencies = dependencies
    }

    func show(_ presentable: ModalPresentable) {
        self.presentable = presentable
    }

    func hide() {
        presentable = nil
    }

    fileprivate func view(for presentable: ModalPresentable) -> some View {
        presentable.view(
            dependencies: dependencies,
            navigation: nil,
            tabbar: nil,
            modal: self
        )
    }
}

struct ModalCoordinatorView: View {
    @StateObject var coordinator: ModalCoordinator

    var body: some View {
        if let presentable = coordinator.presentable {
            coordinator.view(for: presentable)
                .onTapGesture { coordinator.hide() }
        } else {
            EmptyView()
        }
    }
}
