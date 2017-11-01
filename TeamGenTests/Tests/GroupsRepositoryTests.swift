import XCTest
import Nimble
import SQLite
@testable import TeamGen

class GroupsRepositoryTests: XCTestCase {

    private var defaultDatabase: Connection!

    override func setUp() {
        let connection = try! Connection()
        self.defaultDatabase = makeDataBase(with: connection).first()?.value!
    }

    func testMakeGroup() {

        let spec1 = SkillSpec(name: "One skill", minValue: 0, maxValue: 5)
        let spec2 = SkillSpec(name: "Two skills", minValue: 0, maxValue: 10)
        let skill1 = Skill(value: 3, spec: spec1)!
        let skill2 = Skill(value: 3, spec: spec2)!

        let player1 = Player(name: "Player1", skills: [skill1, skill2])
        let player2 = Player(name: "Player2", skills: [skill1, skill2])

        let group = Group(name: "Best group", players: [player1, player2], skillSpec: [spec1, spec2])

        let groupRepository = GroupsRepository(dataBaseConnection: defaultDatabase)
        let returnedGroup = groupRepository.make(group: group).first()?.value

        expect(group).to(equal(returnedGroup))
    }

    func testMakeGroupWithInconsistentSkillSpec() {
        let spec1 = SkillSpec(name: "One skill", minValue: 0, maxValue: 5)
        let spec2 = SkillSpec(name: "Two skills", minValue: 0, maxValue: 10)
        let skill1 = Skill(value: 3, spec: spec1)!
        let skill2 = Skill(value: 3, spec: spec2)!

        let player1 = Player(name: "Player1", skills: [skill1, skill2])
        let player2 = Player(name: "Player2", skills: [skill1, skill2])

        let group = Group(name: "Best group", players: [player1, player2], skillSpec: [spec1])

        let groupRepository = GroupsRepository(dataBaseConnection: defaultDatabase)
        let returnedGroup = groupRepository.make(group: group).first()?.error

        expect(returnedGroup).to(equal(CoreError.inserting("Couldn't find a skillSpec with name Two skills")))
    }
}
