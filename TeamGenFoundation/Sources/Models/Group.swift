public struct Group: Codable, Equatable {
    public let name: String
    public let players: [Player]
    public let skillSpec: [SkillSpec]
    
    public init(name: String, players: [Player], skillSpec: [SkillSpec]) {
        self.name = name
        self.players = players
        self.skillSpec = skillSpec
    }
}
