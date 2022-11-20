import Foundation

public protocol Networking {
    func execute<Response: Decodable>(request: NetworkingRequest) async throws -> Response
}

public class DefaultNetworking: Networking {
    private let session: URLSession
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let requestModifiers: [NetworkingRequestModifier]
    private let errorHandler: NetworkingErrorHandler?

    private init(
        session: URLSession,
        encoder: JSONEncoder,
        decoder: JSONDecoder,
        requestModifiers: [NetworkingRequestModifier],
        errorHandler: NetworkingErrorHandler?
    ) {
        self.session = session
        self.encoder = encoder
        self.decoder = decoder
        self.requestModifiers = requestModifiers
        self.errorHandler = errorHandler
    }

    public convenience init(requestModifiers: [NetworkingRequestModifier] = [],
                            errorHandler: NetworkingErrorHandler? = nil) {
        self.init(
            session: .shared,
            encoder: .standard,
            decoder: .standard,
            requestModifiers: requestModifiers,
            errorHandler: errorHandler
        )
    }

    @MainActor
    public func execute<Response: Decodable>(request: NetworkingRequest) async throws -> Response {
        do {
            return try await fire(request: request)
        } catch let error as NetworkingError {
            let result = await errorHandler?.handle(error: error)
            switch result {
            case .none, .abort: throw error
            case .retry: return try await fire(request: request)
            }
        } catch {
            throw NetworkingError.unknown(error: error)
        }
    }

    private func fire<Response: Decodable>(request: NetworkingRequest) async throws -> Response {
        guard let urlRequest = request.urlRequest(encoder: encoder, requestModifiers: requestModifiers) else {
            throw NetworkingError.invalidRequest
        }
        do {
            let (data, response) = try await session.data(for: urlRequest)
            guard let httpResponse = response as? HTTPURLResponse else {
                throw NetworkingError.invalidResponse
            }
            guard (200...299).contains(httpResponse.statusCode) else {
                let errorResponse = try? decoder.decode(ErrorResponse.self, from: data)
                throw NetworkingError(statusCode: httpResponse.statusCode, message: errorResponse?.message)
            }
            if data.isEmpty, let empty = EmptyResponse() as? Response {
                return empty
            }
            guard let object = try? decoder.decode(Response.self, from: data) else {
                throw NetworkingError.decodingFailed
            }
            return object
        } catch let error as NetworkingError {
            throw error
        } catch {
            throw NetworkingError(error: error)
        }
    }
}
