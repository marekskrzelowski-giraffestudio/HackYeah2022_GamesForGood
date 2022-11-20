import Foundation
import SwiftUI
import Content
import Core
import Combine

final class LearnViewModel: BaseViewModel {
    @Published var name: String = ""
    @Published var missionCards: [MissionPresentable] = []
    @Published var taskCards: [TaskPresentable] = []

    private var missions: [Mission] = []

    override init(
        dependencies: Dependencies,
        navigation: NavigationCoordinator?,
        tabbar: TabbarCoordinator?,
        modal: ModalCoordinator?
    ) {
        super.init(dependencies: dependencies, navigation: navigation, tabbar: tabbar, modal: modal)
    }

    func onAppear() async {
        getUser()
        await fetchMissions()
        await fetchTasks()
    }

    func getUser() {
        let user = dependencies.userService.currentUser
        name = "Sebastian"
    }

    func fetchMissions() async {
        do {
            let missions = try await dependencies.missionsService.fetchMissions(type: "mission", parent: nil)
            let presentables = missions.map(MissionPresentable.init)
            self.missions = missions
            self.missionCards = presentables
        } catch {
            print("Fetch missions error: \(error)")
        }
    }

    func fetchTasks() async {
        let missions = try? await dependencies.missionsService.fetchMissions(type: "task", parent: nil)
        let presentables = missions?.map(TaskPresentable.init)
        taskCards = presentables ?? []
    }

    func missionDetails() {
    }

    func showMissionAction(id: Int) {
        guard let mission = missions.first(where: { $0.id == id}) else { return }
        navigation?.push(.mission(mission))
    }

    func showTaskAction() {
        print("Działaj")
    }
}

struct MissionPresentable: Identifiable {
    let id: Int
    let image: String
    let color: Color
    let title: String
    let subtitle: String
    let score: Int

    init(mission: Mission) {
        self.id = mission.id
        self.image = mission.logo ?? ""
        self.color = Color(hex: mission.color) ?? Content.color(.accentNormal)
        self.title = mission.name
        self.subtitle = mission.missionDescription
        self.score = mission.points
    }
}

struct TaskPresentable: Identifiable {
    let id: Int
    let color: Color
    let title: String
    let subtitle: String
    let score: Int

    init(mission: Mission) {
        self.id = mission.id
        self.color = Color(hex: mission.color) ?? Content.color(.accentNormal)
        self.title = mission.name
        self.subtitle = mission.missionDescription
        self.score = mission.points
    }
}
