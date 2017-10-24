struct Group: Codable {
    let name: String
    let description: String
    let players: [Player]
    let skillSpec: [SkillSpec]
}
