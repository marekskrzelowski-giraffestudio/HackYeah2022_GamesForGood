import Combine

public typealias StorageKey = RawRepresentable & CaseIterable & Hashable

public typealias Subscribable = Codable & Equatable

public protocol Storage {
    func set<Object: Codable, Key: StorageKey>(_ object: Object, for key: Key) throws where Key.RawValue == String
    func get<Object: Codable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> Object? where Key.RawValue == String
    func subscribe<Object: Subscribable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> AnyPublisher<Object?, Never> where Key.RawValue == String
    func delete<Key: StorageKey>(_ key: Key) throws where Key.RawValue == String
    func clear<Key: StorageKey>(_ keys: Key.Type) throws where Key.RawValue == String
}
