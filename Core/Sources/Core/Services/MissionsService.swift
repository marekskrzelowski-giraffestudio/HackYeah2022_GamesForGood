import Networking
import Persistence
import Combine

public protocol MissionsService {
    func fetchMissions(type: String, parent: Int?) async throws -> [Mission]
}

public class DefaultMissionService: MissionsService {
    private let networking: Networking
    private let storage: Storage

    public init(networking: Networking, storage: Storage) {
        self.networking = networking
        self.storage = storage
    }

    public func fetchMissions(type: String, parent: Int?) async throws -> [Mission] {
        let request = MissionsRequest.fetch(body: .init(type: type, parent: parent))
        let response: [Mission] = try await networking.execute(request: request)
        return response
    }
}
