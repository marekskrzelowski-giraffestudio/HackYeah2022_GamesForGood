import Foundation
import Combine

public class DefaultsStorage: Storage {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let userDefaults: UserDefaults

    private init(encoder: JSONEncoder, decoder: JSONDecoder, userDefaults: UserDefaults) {
        self.encoder = encoder
        self.decoder = decoder
        self.userDefaults = userDefaults
    }

    public convenience init() {
        self.init(encoder: .standard, decoder: .standard, userDefaults: .standard)
    }

    public func set<Object: Codable, Key: StorageKey>(
        _ object: Object, for key: Key
    ) throws where Key.RawValue == String {
        do {
            let encoded = try encoder.encode(object)
            userDefaults.set(encoded, forKey: key.rawValue)
        } catch {
            throw StorageError.encodingFailed
        }
    }

    public func get<Object: Codable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> Object? where Key.RawValue == String {
        guard let data = userDefaults.object(forKey: key.rawValue) as? Data else {
            return nil
        }
        do {
            return try decoder.decode(Object.self, from: data)
        } catch {
            throw StorageError.decodingFailed
        }
    }

    public func subscribe<Object: Subscribable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> AnyPublisher<Object?, Never> where Key.RawValue == String {
        throw StorageError.notSupported
    }

    public func delete<Key: StorageKey>(_ key: Key) throws where Key.RawValue == String {
        userDefaults.removeObject(forKey: key.rawValue)
    }

    public func clear<Key: StorageKey>(_ keys: Key.Type) throws where Key.RawValue == String {
        try Key.allCases.forEach(delete)
    }
}
