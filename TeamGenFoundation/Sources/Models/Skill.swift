public struct Skill: Codable, Equatable {
    public let value: Double
    public let spec: SkillSpec

    public init?(value: Double, spec: SkillSpec) {
        guard value >= spec.minValue && value <= spec.maxValue else { return nil }
        self.value = value
        self.spec = spec
    }
}

public struct SkillSpec: Codable, Equatable {
    public let name: String
    public let minValue: Double
    public let maxValue: Double

    public init(name: String, minValue: Double, maxValue: Double) {
        self.name = name
        self.minValue = minValue
        self.maxValue = maxValue
    }
}
