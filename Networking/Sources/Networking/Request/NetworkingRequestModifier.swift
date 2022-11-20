import Foundation

public protocol NetworkingRequestModifier {
    func modify(request: URLRequest) -> URLRequest
}
