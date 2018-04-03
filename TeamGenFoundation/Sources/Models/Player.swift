public struct Player: Codable {
    public let name: String
    public let skills: [Skill]

    public init(name: String, skills: [Skill]) {
        self.name = name
        self.skills = skills
    }

    public var total: Double {
        func reducer(acc: Double, skill: Skill) -> Double {
            return acc + skill.value
        }

        return skills.reduce(0.0, reducer)
    }
}

extension Player: Equatable {
   public static func ==(lhs: Player, rhs: Player) -> Bool {
        return lhs.name == rhs.name &&
            lhs.skills == rhs.skills
    }
}
