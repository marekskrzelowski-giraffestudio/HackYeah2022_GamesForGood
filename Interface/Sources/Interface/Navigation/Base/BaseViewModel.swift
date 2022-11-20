import Foundation

@MainActor class BaseViewModel: ObservableObject {
    let dependencies: Dependencies
    let navigation: NavigationCoordinator?
    let tabbar: TabbarCoordinator?
    let modal: ModalCoordinator?

    init(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) {
        self.dependencies = dependencies
        self.navigation = navigation
        self.tabbar = tabbar
        self.modal = modal
    }
}
