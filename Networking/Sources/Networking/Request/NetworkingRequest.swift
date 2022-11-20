import Foundation

public protocol NetworkingRequest {
    var basePath: String { get }
    var endpoint: String { get }
    var method: HTTPMethod { get }
    var headers: [HTTPHeader] { get }
    var queryItems: [HTTPQueryItem] { get }
    var body: HTTPBody? { get }
    var boundary: String { get }
    var data: Data? { get }
}

extension NetworkingRequest {
    func urlRequest(encoder: JSONEncoder, requestModifiers: [NetworkingRequestModifier]) -> URLRequest? {
        var components = URLComponents(string: basePath.appending(endpoint))
        components?.queryItems = queryItems.map { URLQueryItem(name: $0.name, value: $0.value) }
        guard let url = components?.url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = method.rawValue
        request.httpBody = body?.encode(encoder: encoder) ?? formattedFileData
        headers.forEach { request.setValue($0.value, forHTTPHeaderField: $0.name) }
        return requestModifiers.reduce(into: request) { $0 = $1.modify(request: $0) }
    }

    private var formattedFileData: Data? {
        guard let data = data else { return nil }
        let body = NSMutableData()
        body.append(string: "\r\n--\(boundary)\r\n")
        body.append(string: "Content-Disposition: form-data; name=\"file\"; filename=\"\(UUID().uuidString)\"\r\n")
        body.append(string: "Content-Type: image/jpeg\r\n\r\n")
        body.append(data)
        body.append(string: "\r\n--\(boundary)--\r\n")
        return body as Data
    }
}
