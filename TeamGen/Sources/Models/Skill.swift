struct Skill: Codable {
    let value: Double
    let spec: SkillSpec
}

struct SkillSpec: Codable {
    let name: String
    let minValue: Double
    let maxValue: Double
}
