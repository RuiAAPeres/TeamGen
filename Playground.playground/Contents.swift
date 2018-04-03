import TeamGenFoundation
import ReactiveSwift
import Result


let passSS = SkillSpec(name: "Pass", minValue: 0, maxValue: 5)
let shootSS = SkillSpec(name: "Shoot", minValue: 0, maxValue: 5)
let runSS = SkillSpec(name: "Run", minValue: 0, maxValue: 5)
let staminaSS = SkillSpec(name: "Stamina", minValue: 0, maxValue: 5)
let dribbleSS = SkillSpec(name: "Dribble", minValue: 0, maxValue: 5)

func toSkill(values: [Double]) -> [Skill] {
    return [
    Skill(value: values[0], spec: passSS)!,
    Skill(value: values[1], spec: shootSS)!,
    Skill(value: values[2], spec: staminaSS)!,
    Skill(value: values[3], spec: dribbleSS)!
    ]
}
                                        //      Pass   Shoot  Stamina Dribble
let rui = Player(name: "Rui",           skills: [4.6,  4.6,   4.9,    4.2] |> toSkill)
let jack = Player(name: "Jack",         skills: [4.6,  4.4,   4.5,    4.5] |> toSkill)
let emilio = Player(name: "Emilio",     skills: [4.5,  4.2,   4.8,    4.2] |> toSkill)
let sergey = Player(name: "Sergey",     skills: [4.8,  4.6,   3.5,    4.5] |> toSkill)
let adrian = Player(name: "Adrian",     skills: [3.5,  3.5,   3.7,    2.7] |> toSkill)
let domenico = Player(name: "Domenico", skills: [3.7,  3.9,   4.3,    3.5] |> toSkill)
let anthony = Player(name: "Anthony",   skills: [3.1,  3.7,   3.3,    2.0] |> toSkill)
let joaoG = Player(name: "Joao G.",     skills: [3.4,  3.0,   3.5,    3.2] |> toSkill)
let shjeel = Player(name: "Shjeel",     skills: [3.6,  3.5,   4.0,    3.6] |> toSkill)
let wilhelm = Player(name: "Wilhelm",   skills: [3.7,  3.5,   3.6,    2.5] |> toSkill)
let rupert = Player(name: "Rupert",     skills: [3.5,  3.0,   3.7,    2.2] |> toSkill)
let giorgios = Player(name: "Giorgios", skills: [3.9,  3.8,   3.6,    3.5] |> toSkill)
let ilya = Player(name: "Ilya",         skills: [2.0,  2.0,   2.0,    2.0] |> toSkill)
let tomas = Player(name: "Tomas",       skills: [2.5,  2.0,   2.6,    1] |> toSkill)

// 14 - 14 22/04/2018
//generateTeams([rui, jack, emilio, adrian, domenico, anthony, joaoG, shjeel, wilhelm, rupert]) |> prettyPrint

// 14 - 14 29/04/2018
generateTeams([rui, jack, emilio, sergey, domenico, anthony, tomas, ilya, wilhelm, rupert]) |> prettyPrint


