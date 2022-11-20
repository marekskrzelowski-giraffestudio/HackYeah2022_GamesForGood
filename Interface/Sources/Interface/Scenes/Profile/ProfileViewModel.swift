import Foundation
import UIKit
import Content
import Core
import Combine

final class ProfileViewModel: BaseViewModel {
    override init(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) {
        super.init(
            dependencies: dependencies,
            navigation: navigation,
            tabbar: tabbar,
            modal: modal
        )
    }

    func onAppear() {

    }

    func fetchRecent() async {

    }

    func logout() {
        do {
            try dependencies.authService.logout()
        } catch {
            fatalError("Logout error")
        }
    }
}
