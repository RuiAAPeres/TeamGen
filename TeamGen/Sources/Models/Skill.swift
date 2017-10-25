struct Skill: Codable {
    let value: Double
    let spec: SkillSpec

    init?(value: Double, spec: SkillSpec) {
        guard value >= spec.minValue && value <= spec.maxValue else { return nil }
        self.value = value
        self.spec = spec
    }
}

extension Skill: Equatable {
    static func ==(lhs: Skill, rhs: Skill) -> Bool {
        return lhs.value == rhs.value &&
            lhs.spec == rhs.spec
    }
}

struct SkillSpec: Codable {
    let name: String
    let minValue: Double
    let maxValue: Double
}

extension SkillSpec: Equatable {
    static func ==(lhs: SkillSpec, rhs: SkillSpec) -> Bool {
        return lhs.name == rhs.name &&
            lhs.minValue == rhs.minValue &&
            lhs.maxValue == rhs.maxValue
    }
}
