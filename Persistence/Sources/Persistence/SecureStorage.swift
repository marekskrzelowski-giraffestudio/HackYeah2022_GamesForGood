import Foundation
import Combine

public class SecureStorage: Storage {
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder

    private init(encoder: JSONEncoder, decoder: JSONDecoder) {
        self.encoder = encoder
        self.decoder = decoder
    }

    public convenience init() {
        self.init(encoder: .standard, decoder: .standard)
    }

    public func set<Object: Codable, Key: StorageKey>(
        _ object: Object, for key: Key
    ) throws where Key.RawValue == String {
        guard let data = try? encoder.encode(object) else {
            throw StorageError.encodingFailed
        }
        let query = setQuery(key: key.rawValue, data: data)
        let legacyQuery = legacySetQuery(key: key.rawValue, data: data)
        if SecItemCopyMatching(query, nil) == errSecItemNotFound {
            if SecItemCopyMatching(legacyQuery, nil) == errSecItemNotFound {
                if SecItemAdd(query, nil) != errSecSuccess {
                    throw StorageError.settingFailed
                }
            } else {
                let updateQuery = [
                    kSecValueData as String: data,
                    kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
                ] as CFDictionary
                if SecItemUpdate(legacyQuery, updateQuery) != errSecSuccess {
                    throw StorageError.settingFailed
                }
            }
        } else {
            let updateQuery = [kSecValueData as String: data] as CFDictionary
            if SecItemUpdate(query, updateQuery) != errSecSuccess {
                throw StorageError.settingFailed
            }
        }
    }

    public func get<Object: Codable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> Object? where Key.RawValue == String {
        let query = getQuery(key: key.rawValue)
        var item: CFTypeRef?
        let status = SecItemCopyMatching(query, &item)
        if status == errSecItemNotFound {
            return nil
        } else if status == errSecSuccess,
                  let existingItem = item as? [String: Any],
                  let data = existingItem[kSecValueData as String] as? Data,
                  let object = try? decoder.decode(Object.self, from: data) {
            return object
        } else {
            throw StorageError.decodingFailed
        }
    }

    public func subscribe<Object: Subscribable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> AnyPublisher<Object?, Never> where Key.RawValue == String {
        throw StorageError.notSupported
    }

    public func delete<Key: StorageKey>(_ key: Key) throws where Key.RawValue == String {
        let query = deleteQuery(key: key.rawValue)
        let status = SecItemDelete(query)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw StorageError.deletingFailed
        }
    }

    public func clear<Key: StorageKey>(_ keys: Key.Type) throws where Key.RawValue == String {
        try Key.allCases.forEach(delete)
    }

    private func setQuery(key: String, data: Data) -> CFDictionary {
        let query: [String: Any] = [
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        return query as CFDictionary
    }

    private func legacySetQuery(key: String, data: Data) -> CFDictionary {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data
        ]
        return query as CFDictionary
    }

    private func getQuery(key: String) -> CFDictionary {
        let query: [String: Any] = [
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecReturnAttributes as String: true,
            kSecReturnData as String: true
        ]
        return query as CFDictionary
    }

    private func deleteQuery(key: String) -> CFDictionary {
        let query: [String: Any] = [
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock,
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key
        ]
        return query as CFDictionary
    }
}
