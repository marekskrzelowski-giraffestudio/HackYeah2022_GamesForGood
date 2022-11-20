import Networking
import Persistence
import Combine
import Foundation

@MainActor public protocol UserService {
    var user: AnyPublisher<User?, Never> { get }
    var currentUser: User? { get }
    func refreshUser() async throws
    func user(id: Int) async throws -> User
}

public class DefaultUserService: UserService {
    private let networking: Networking
    private let defaultsStorage: Storage
    private let memoryStorage: Storage

    public init(networking: Networking, defaultsStorage: Storage, memoryStorage: Storage) {
        self.networking = networking
        self.defaultsStorage = defaultsStorage
        self.memoryStorage = memoryStorage
        setup()
    }

    public var user: AnyPublisher<User?, Never> {
        do {
            return try memoryStorage.subscribe(User.self, for: MemoryKey.user)
        } catch {
            return Just(nil)
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }
    }

    public var currentUser: User? {
        try? memoryStorage.get(User.self, for: MemoryKey.user)
    }

    public func refreshUser() async throws {
        let request = UserRequest.myself
        let response: UserResponse = try await networking.execute(request: request)
        let user = User(response: response)
        try defaultsStorage.set(user, for: DefaultsKey.user)
        try memoryStorage.set(user, for: MemoryKey.user)
    }

    public func user(id: Int) async throws -> User {
        let request = UserRequest.user(id: id)
        let response: UserResponse = try await networking.execute(request: request)
        return User(response: response)
    }

    private func setup() {
        if let user = try? defaultsStorage.get(User.self, for: DefaultsKey.user) {
            try? memoryStorage.set(user, for: MemoryKey.user)
        }
    }
}
