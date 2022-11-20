struct AuthResponse: Decodable {
    let token: String
    let refreshToken: String
    let user: UserResponse
}
