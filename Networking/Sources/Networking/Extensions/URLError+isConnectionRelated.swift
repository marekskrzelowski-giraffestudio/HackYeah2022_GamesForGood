import Foundation

extension URLError {
    var isConnectionRelated: Bool {
        connectionCodes.contains(code)
    }

    private var connectionCodes: [Code] {
        [
            .cannotConnectToHost,
            .dataNotAllowed,
            .dnsLookupFailed,
            .internationalRoamingOff,
            .networkConnectionLost,
            .notConnectedToInternet,
            .secureConnectionFailed,
            .timedOut
        ]
    }
}
