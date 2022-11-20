import Foundation
import SwiftUI
import Content
import Core
import Combine

final class MissionDetailsViewModel: BaseViewModel {

    @Published var mission: Mission
    @Published var tasks: [TasksPresentable] = []

    init(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?,
        mission: Mission
    ) {
        self.mission = mission
        super.init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
    }

    func onAppear() async {
        await fetchTasks()
    }

    func fetchTasks() async {
        do {
            let tasks = try await dependencies.missionsService.fetchMissions(type: "task", parent: mission.id)
            let presentables = tasks.map {
                TasksPresentable(
                    id: $0.id,
                    title: "+ \($0.points) punktów",
                    subtitle: $0.name,
                    color: $0.color,
                    image: $0.logo ?? ""
                )
            }
            self.tasks = presentables
        } catch {
            print("Fetch tasks \(error)")
        }
    }
}

struct TasksPresentable: Identifiable {
    let id: Int
    let title: String
    let subtitle: String
    let color: String
    let image: String
}
