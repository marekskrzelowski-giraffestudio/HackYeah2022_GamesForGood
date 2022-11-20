import Foundation
import Networking
import Persistence

public class AccessTokenInserter: NetworkingRequestModifier {
    private let storage: Storage

    public init(storage: Storage) {
        self.storage = storage
    }

    public func modify(request: URLRequest) -> URLRequest {
        guard let accessToken = try? storage.get(String.self, for: SecureKey.accessToken) else { return request }
        var modifiedRequest = request
        let header = HTTPHeader.bearerAuthorization(accessToken)
        modifiedRequest.setValue(header.value, forHTTPHeaderField: header.name)
        return modifiedRequest
    }
}
