import Networking

public actor UnauthorizedErrorHandler: NetworkingErrorHandler {
    private let authService: AuthService
    private var task: Task<NetworkingErrorHandlerResult, Never>?

    public init(authService: AuthService) {
        self.authService = authService
    }

    public func handle(error: NetworkingError) async -> NetworkingErrorHandlerResult {
        guard case NetworkingError.unauthorized = error else { return .abort }
        if let task = task {
            return await task.value
        }
        task = Task {
            defer { task = nil }
            do {
                if try await authService.refresh() {
                    return .retry
                } else {
                    try? await authService.logout()
                    return .abort
                }
            } catch {
                try? await authService.logout()
                return .abort
            }
        }
        return await task?.value ?? .abort
    }
}
