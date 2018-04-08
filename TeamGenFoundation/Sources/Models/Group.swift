public struct Group: Codable, Equatable {
    public let name: String
    public let players: [Player]
    public let skillSpec: [SkillSpec]
}
