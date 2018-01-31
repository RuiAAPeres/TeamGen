public struct Group: Codable {
    public let name: String
    public let players: [Player]
    public let skillSpec: [SkillSpec]
}

extension Group: Equatable {
    public static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name &&
            lhs.players == rhs.players &&
            lhs.skillSpec == rhs.skillSpec
    }
}
