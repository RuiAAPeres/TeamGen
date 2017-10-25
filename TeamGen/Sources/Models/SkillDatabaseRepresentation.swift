import SQLite

struct SkillDatabaseRepresentation {
    let table = Table("Skills")
    let id = Expression<Int64>("id")
    let value = Expression<Double>("value")
    let skillSpecForeign = Expression<Int64>("skillSpec")
    let playerForeign = Expression<Int64>("player")
}

struct SkillSpecDatabaseRepresentation {
    let table = Table("SkillSpecs")
    let id = Expression<Int64>("id")
    let name = Expression<String>("name")
    let minValue = Expression<Double>("minValue")
    let maxValue = Expression<Double>("maxValue")
    let groupForeign = Expression<Int64>("group")
}



