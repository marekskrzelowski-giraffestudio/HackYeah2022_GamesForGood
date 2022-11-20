import Foundation

public typealias HTTPBody = Encodable

extension HTTPBody {
    func encode(encoder: JSONEncoder) -> Data? {
        try? encoder.encode(self)
    }
}
