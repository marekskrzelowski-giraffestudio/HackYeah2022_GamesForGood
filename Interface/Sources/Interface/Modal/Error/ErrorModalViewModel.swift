final class ErrorModalViewModel: BaseViewModel {
    let message: String?

    init(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?,
        message: String?
    ) {
        self.message = message
        super.init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
    }

    func dismiss() {
        modal?.hide()
    }
}
