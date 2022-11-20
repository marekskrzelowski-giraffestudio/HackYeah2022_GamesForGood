import SwiftUI
import Combine
import IQKeyboardManagerSwift

@MainActor final class MainViewModel: ObservableObject {
    @Published var blur: Bool = false
    @Published var logged: Bool = false
    private let keyboardManager: IQKeyboardManager = .shared
    private let dependencies: Dependencies = .init()
    lazy var modal: ModalCoordinator = .init(dependencies: dependencies)
    var tabbar: TabbarCoordinator {
        .init(dependencies: dependencies, modal: modal, presentable: .learn)
    }
    
    var onboarding: NavigationCoordinator {
        .init(dependencies: dependencies, tabbar: tabbar, modal: modal, root: .login)
    }

    init() {
        setup()
    }

    private func setup() {
        dependencies.authService.isLoggedIn
            .assign(to: &$logged)
        modal.$presentable
            .map { $0 != nil }
            .assign(to: &$blur)
        setupKeyboardManager()
    }

    private func setupKeyboardManager() {
        keyboardManager.enable = true
        keyboardManager.enableAutoToolbar = false
        keyboardManager.shouldShowToolbarPlaceholder = false
        keyboardManager.shouldResignOnTouchOutside = true
        keyboardManager.previousNextDisplayMode = .alwaysHide
    }
}
