public struct Player: Codable {
    public let name: String
    public let skills: [Skill]
}

extension Player: Equatable {
   public static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name &&
            lhs.skills == rhs.skills
    }
}
