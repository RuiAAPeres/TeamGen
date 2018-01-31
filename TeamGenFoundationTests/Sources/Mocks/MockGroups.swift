@testable import TeamGenFoundation

var group1: Group = {
    let spec1 = SkillSpec(name: "One skill", minValue: 0, maxValue: 5)
    let spec2 = SkillSpec(name: "Two skill", minValue: 0, maxValue: 10)
    let skill1 = Skill(value: 3, spec: spec1)!
    let skill2 = Skill(value: 3, spec: spec2)!

    let player1 = Player(name: "Player1", skills: [skill1, skill2])
    let player2 = Player(name: "Player2", skills: [skill1, skill2])

    let group = Group(name: "Best group 1", players: [player1, player2], skillSpec: [spec1, spec2])

    return group
}()

var group2: Group = {
    let spec1 = SkillSpec(name: "Third skill", minValue: 0, maxValue: 5)
    let spec2 = SkillSpec(name: "Fourth skill", minValue: 0, maxValue: 10)
    let spec3 = SkillSpec(name: "Fifth skill", minValue: 0, maxValue: 10)
    let spec4 = SkillSpec(name: "Sixth skill", minValue: 0, maxValue: 4)

    let skill11 = Skill(value: 2, spec: spec1)!
    let skill12 = Skill(value: 5, spec: spec2)!
    let skill13 = Skill(value: 10, spec: spec3)!
    let skill14 = Skill(value: 4, spec: spec4)!

    let skill21 = Skill(value: 1, spec: spec1)!
    let skill22 = Skill(value: 10, spec: spec2)!
    let skill23 = Skill(value: 10, spec: spec3)!
    let skill24 = Skill(value: 4, spec: spec4)!

    let player1 = Player(name: "Player3", skills: [skill11, skill12, skill13, skill14])
    let player2 = Player(name: "Player4", skills: [skill11, skill12, skill13, skill14])
    let player3 = Player(name: "Player5", skills: [skill21, skill22, skill23, skill24])
    let player4 = Player(name: "Player6", skills: [skill21, skill22, skill23, skill24])
    let player5 = Player(name: "Player7", skills: [skill11, skill12, skill13, skill14])
    let player6 = Player(name: "Player8", skills: [skill11, skill12, skill13, skill14])

    let group = Group(name: "Best group 2", players: [player1, player2, player3, player4, player5, player6], skillSpec: [spec1, spec2, spec3, spec4])

    return group
}()
