public enum NetworkingErrorHandlerResult {
    case abort
    case retry
}

public protocol NetworkingErrorHandler {
    func handle(error: NetworkingError) async -> NetworkingErrorHandlerResult
}
