import Foundation
import Networking

enum AuthRequest: NetworkingRequest {
    private static let uuid = UUID().uuidString

    case login(body: LoginBody)
    case refresh(body: RefreshBody)

    var basePath: String {
        Configuration.apiURL
    }

    var endpoint: String {
        switch self {
        case .login: return "auth/login"
        case .refresh: return "auth/refresh-token"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .login: return .post
        case .refresh: return .post
        }
    }

    var headers: [HTTPHeader] {
        switch self {
        case .login: return [.defaultUserAgent, .jsonContentType]
        case .refresh: return [.defaultUserAgent, .jsonContentType]
        }
    }

    var queryItems: [HTTPQueryItem] {
        switch self {
        case .login: return []
        case .refresh: return []
        }
    }

    var body: HTTPBody? {
        switch self {
        case let .login(body): return body
        case let .refresh(body): return body
        }
    }

    var boundary: String {
        Self.uuid
    }

    var data: Data? {
        switch self {
        case .login: return nil
        case .refresh: return nil
        }
    }
}
