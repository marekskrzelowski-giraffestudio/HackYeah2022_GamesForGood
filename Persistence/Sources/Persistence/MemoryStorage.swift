import Foundation
import Combine

public class MemoryStorage: Storage {
    private typealias Memory = [String: Data]
    private let encoder: JSONEncoder
    private let decoder: JSONDecoder
    private let subject: CurrentValueSubject<Memory, Never>
    private var memory: Memory { didSet { subject.send(memory) } }

    private init(
        encoder: JSONEncoder,
        decoder: JSONDecoder,
        subject: CurrentValueSubject<Memory, Never>,
        memory: Memory
    ) {
        self.encoder = encoder
        self.decoder = decoder
        self.subject = subject
        self.memory = memory
    }

    public convenience init() {
        self.init(
            encoder: .standard,
            decoder: .standard,
            subject: .init(.init()),
            memory: .init()
        )
    }

    public func set<Object: Codable, Key: StorageKey>(
        _ object: Object, for key: Key
    ) throws where Key.RawValue == String {
        do {
            memory[key.rawValue] = try encoder.encode(object)
        } catch {
            throw StorageError.encodingFailed
        }
    }

    public func get<Object: Codable, Key: StorageKey>(
        _ type: Object.Type, for key: Key
    ) throws -> Object? where Key.RawValue == String {
        guard let data = memory[key.rawValue] else {
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
        subject
            .map { [weak decoder] storage in
                guard let data = storage[key.rawValue] else { return nil }
                return try? decoder?.decode(Object.self, from: data)
            }
            .removeDuplicates()
            .eraseToAnyPublisher()
    }

    public func delete<Key: StorageKey>(_ key: Key) throws where Key.RawValue == String {
        memory.removeValue(forKey: key.rawValue)
    }

    public func clear<Key: StorageKey>(_ keys: Key.Type) throws where Key.RawValue == String {
        try Key.allCases.forEach(delete)
    }
}
