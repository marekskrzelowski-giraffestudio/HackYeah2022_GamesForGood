import Foundation

extension NSMutableData {
    func append(string: String) {
        if let data = string.data(using: .utf8) {
            append(data)
        }
    }
}
