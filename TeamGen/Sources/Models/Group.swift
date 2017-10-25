struct Group: Codable {
    let name: String
    let players: [Player]
    let skillSpec: [SkillSpec]
}

extension Group: Equatable {
    static func ==(lhs: Group, rhs: Group) -> Bool {
        return lhs.name == rhs.name &&
            lhs.players == rhs.players &&
            lhs.skillSpec == rhs.skillSpec
    }
}
