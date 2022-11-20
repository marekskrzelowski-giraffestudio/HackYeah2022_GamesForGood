import Persistence

enum SecureKey: String, StorageKey {
    case accessToken
    case refreshToken
}
