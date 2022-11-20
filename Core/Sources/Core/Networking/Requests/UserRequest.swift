import Foundation
import Networking

enum UserRequest: NetworkingRequest {
    private static let uuid = UUID().uuidString

    case myself
    case user(id: Int)

    var basePath: String {
        Configuration.apiURL
    }

    var endpoint: String {
        switch self {
        case .myself: return "user/me"
        case let .user(id): return "user/\(id)"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .myself: return .get
        case .user: return .get
        }
    }

    var headers: [HTTPHeader] {
        switch self {
        case .myself: return [.defaultUserAgent, .jsonContentType]
        case .user: return [.defaultUserAgent, .jsonContentType]
        }
    }

    var queryItems: [HTTPQueryItem] {
        switch self {
        case .myself: return []
        case .user: return []
        }
    }

    var body: HTTPBody? {
        switch self {
        case .myself: return nil
        case .user: return nil
        }
    }

    var boundary: String {
        Self.uuid
    }

    var data: Data? {
        switch self {
        case .myself: return nil
        case .user: return nil
        }
    }
}
