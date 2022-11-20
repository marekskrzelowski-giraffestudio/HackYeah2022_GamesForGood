import Foundation

public struct User: Codable, Hashable, Equatable {
    public let id: Int
    public let email: String
    public let username: String

    init(response: UserResponse) {
        id = response.id
        email = response.email
        username = response.username
    }
}
