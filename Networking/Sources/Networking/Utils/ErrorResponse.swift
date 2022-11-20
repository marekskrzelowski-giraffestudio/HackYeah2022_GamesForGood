struct ErrorResponse: Decodable {
    let statusCode: Int
    let message: String
    let error: String
}
