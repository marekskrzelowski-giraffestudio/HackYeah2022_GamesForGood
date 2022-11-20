import Foundation
import Networking
import Persistence
import Combine

@MainActor public protocol AuthService {
    var isLoggedIn: AnyPublisher<Bool, Never> { get }
    func login(email: String, password: String) async throws
    func refresh() async throws -> Bool
    func logout() throws
}

public class DefaultAuthService: AuthService {
    private let networking: Networking
    private let secureStorage: Storage
    private let defaultsStorage: Storage
    private let memoryStorage: Storage

    public init(
        networking: Networking,
        secureStorage: Storage,
        defaultsStorage: Storage,
        memoryStorage: Storage
    ) {
        self.networking = networking
        self.secureStorage = secureStorage
        self.defaultsStorage = defaultsStorage
        self.memoryStorage = memoryStorage
    }

    public var isLoggedIn: AnyPublisher<Bool, Never> {
        do {
            return try memoryStorage
                .subscribe(User.self, for: MemoryKey.user)
                .map { $0 != nil }
                .removeDuplicates()
                .eraseToAnyPublisher()
        } catch {
            return Just(false)
                .setFailureType(to: Never.self)
                .eraseToAnyPublisher()
        }
    }

    public func login(email: String, password: String) async throws {
        let request = AuthRequest.login(body: .init(email: email, password: password))
        let response: AuthResponse = try await networking.execute(request: request)
        try secureStorage.set(response.token, for: SecureKey.accessToken)
        try secureStorage.set(response.refreshToken, for: SecureKey.refreshToken)
        let user = User(response: response.user)
        try defaultsStorage.set(user, for: DefaultsKey.user)
        try memoryStorage.set(user, for: MemoryKey.user)
    }

    public func refresh() async throws -> Bool {
        guard let refreshToken = try secureStorage.get(String.self, for: SecureKey.refreshToken) else { return false }
        let request = AuthRequest.refresh(body: .init(refreshToken: refreshToken))
        let response: AuthResponse = try await networking.execute(request: request)
        try secureStorage.set(response.token, for: SecureKey.accessToken)
        try secureStorage.set(response.refreshToken, for: SecureKey.refreshToken)
        return true
    }

    public func logout() throws {
        try secureStorage.clear(SecureKey.self)
        try defaultsStorage.clear(DefaultsKey.self)
        try memoryStorage.delete(MemoryKey.user)
    }
}
