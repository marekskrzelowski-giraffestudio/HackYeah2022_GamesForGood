import SwiftUI

protocol Presentable {
    associatedtype PresentedView: View
    @MainActor @ViewBuilder func view(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) -> PresentedView
}
