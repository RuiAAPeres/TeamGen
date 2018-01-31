public struct Skill: Codable {
    public let value: Double
    public let spec: SkillSpec

    init?(value: Double, spec: SkillSpec) {
        guard value >= spec.minValue && value <= spec.maxValue else { return nil }
        self.value = value
        self.spec = spec
    }
}

extension Skill: Equatable {
    public static func ==(lhs: Skill, rhs: Skill) -> Bool {
        return lhs.value == rhs.value &&
            lhs.spec == rhs.spec
    }
}

public struct SkillSpec: Codable {
    public let name: String
    public let minValue: Double
    public let maxValue: Double
}

extension SkillSpec: Equatable {
    public static func ==(lhs: SkillSpec, rhs: SkillSpec) -> Bool {
        return lhs.name == rhs.name &&
            lhs.minValue == rhs.minValue &&
            lhs.maxValue == rhs.maxValue
    }
}
