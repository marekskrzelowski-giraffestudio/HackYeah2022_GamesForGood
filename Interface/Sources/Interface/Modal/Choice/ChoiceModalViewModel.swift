final class ChoiceModalViewModel: BaseViewModel {
    let title: String
    let message: String
    let confirm: () -> Void

    init(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?,
        title: String,
        message: String,
        confirm: @escaping () -> Void
    ) {
        self.title = title
        self.message = message
        self.confirm = confirm
        super.init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
    }

    func cancel() {
        modal?.hide()
    }
}
