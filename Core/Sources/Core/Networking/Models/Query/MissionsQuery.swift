import Networking

struct MissionsQuery: HTTPBody {
    let type: String
    let parent: Int?

    var parentID: String {
        guard let id = parent else {
            return ""
        }
        return String(id)
    }

    var items: [HTTPQueryItem] {
        [
            HTTPQueryItem(name: "type", value: String(type)),
            HTTPQueryItem(name: "parent", value: parentID)
        ].compactMap { $0 }
    }
}
