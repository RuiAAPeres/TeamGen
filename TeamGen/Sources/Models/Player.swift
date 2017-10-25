struct Player: Codable {
    let name: String
    let skills: [Skill]
}

extension Player: Equatable {
    static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name &&
            lhs.skills == rhs.skills
    }
}
