import Foundation

public enum NetworkingError: Error {
    case invalidRequest
    case invalidResponse
    case decodingFailed
    case connectionFailed
    case badRequest(message: String?)
    case unauthorized(message: String?)
    case forbidden(message: String?)
    case resourceNotFound(message: String?)
    case other(code: Int, message: String?)
    case unknown(error: Error)

    init(statusCode: Int, message: String?) {
        switch statusCode {
        case 400: self = .badRequest(message: message)
        case 401: self = .unauthorized(message: message)
        case 403: self = .forbidden(message: message)
        case 404: self = .resourceNotFound(message: message)
        default: self = .other(code: statusCode, message: message)
        }
    }

    init(error: Error) {
        if let error = error as? URLError, error.isConnectionRelated {
            self = .connectionFailed
        } else {
            self = .unknown(error: error)
        }
    }

    public var message: String? {
        switch self {
        case let .badRequest(message),
            let .unauthorized(message),
            let .forbidden(message),
            let .resourceNotFound(message),
            let .other(_, message):
            return message
        default:
            return nil
        }
    }
}
