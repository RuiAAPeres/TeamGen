import XCTest
import Nimble
import Disk
import Result
@testable import TeamGenFoundation

class GroupsRepositoryTests: XCTestCase {

    private var groupRepository = GroupsRepository()

    override func setUp() {
       try! Disk.clear(.applicationSupport)
    }

    func testMakeGroupWithInconsistentSkillSpec() {

        let spec1 = SkillSpec(name: "One skill", minValue: 0, maxValue: 5)
        let spec2 = SkillSpec(name: "Two skill", minValue: 0, maxValue: 10)
        let skill1 = Skill(value: 3, spec: spec1)!
        let skill2 = Skill(value: 3, spec: spec2)!

        let player1 = Player(name: "Player1", skills: [skill1, skill2])
        let player2 = Player(name: "Player2", skills: [skill1, skill2])

        let group = Group(name: "Best group 1", players: [player1, player2], skillSpec: [spec1])

        let error = groupRepository.insert(group: group).first()?.error

        expect(error).to(equal(CoreError.inserting("Invalid group")))
    }

    func testMakeGroupTwice() {
        _ = groupRepository.insert(group: group1).first()?.value
        let error = groupRepository.insert(group: group1).first()?.error

        expect(error).to(equal(CoreError.inserting("Already exists")))
    }

    func testRetrieveCorrectGroup() {
        _ = groupRepository.insert(group: group1).first()?.value
        let returnedGroup = groupRepository.insert(group: group2).first()?.value

        expect(group2).to(equal(returnedGroup))
    }

    func testDeleteGroup() {
        let group = groupRepository.insert(group: group1).first()!.value!
        let outcome: Void? = groupRepository.delete(withName: group.name).first()?.value

        expect(outcome).toNot(beNil())

        let error = groupRepository.group(withName: group.name).first()?.error
        expect(error).to(equal(CoreError.reading("Best group 1 not found")))
    }
}
