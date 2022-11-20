public struct Mission: Codable {
    public let id: Int
    public let name: String
    public let type: String
    public let parent: Int?
    public let logo: String?
    public let missionDescription: String
    public let color: String
    public let points: Int
    public let knowledgePill: String

    enum CodingKeys: String, CodingKey {
        case id = "id"
        case name = "name"
        case type = "type"
        case parent = "parent"
        case logo = "logo"
        case missionDescription = "description"
        case color = "color"
        case points = "points"
        case knowledgePill = "knowledgePill"
    }
}
