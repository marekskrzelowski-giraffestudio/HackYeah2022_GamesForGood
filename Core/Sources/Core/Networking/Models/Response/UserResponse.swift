struct UserResponse: Codable {
    let id: Int
    let createdAt: String
    let updatedAt: String
    let username: String
    let email: String
    let role: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case createdAt = "createdAt"
        case updatedAt = "updatedAt"
        case username = "username"
        case email = "email"
        case role = "role"
    }
}
