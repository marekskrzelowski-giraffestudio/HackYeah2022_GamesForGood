import Foundation
import Networking

enum MissionsRequest: NetworkingRequest {
    private static let uuid = UUID().uuidString

    case fetch(body: MissionsQuery)

    var basePath: String {
        Configuration.apiURL
    }

    var endpoint: String {
        switch self {
        case .fetch: return "tasks"
        }
    }

    var method: HTTPMethod {
        switch self {
        case .fetch: return .get
        }
    }

    var headers: [HTTPHeader] {
        switch self {
        case .fetch: return [.defaultUserAgent, .jsonContentType]
        }
    }

    var queryItems: [HTTPQueryItem] {
        switch self {
        case let .fetch(query): return query.items
        }
    }

    var body: HTTPBody? {
        switch self {
        case .fetch: return nil
        }
    }

    var boundary: String {
        Self.uuid
    }

    var data: Data? {
        switch self {
        case .fetch: return nil
        }
    }
}
