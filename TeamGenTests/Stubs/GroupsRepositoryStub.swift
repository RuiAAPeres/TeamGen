import ReactiveSwift
@testable import TeamGen

struct GroupsRepositoryStub: GroupsRepositoryProtocol {

    var _groups: SignalProducer<[Group], CoreError>!
    var _group: SignalProducer<Group, CoreError>!
    var _delete: SignalProducer<Void, CoreError>!
    var _insert: SignalProducer<Group, CoreError>!
    var _update: SignalProducer<Group, CoreError>!

    func groups() -> SignalProducer<[Group], CoreError> {
        return _groups
    }

    func group(withName name: String) -> SignalProducer<Group, CoreError> {
        return _group
    }

    func delete(withName name: String) -> SignalProducer<Void, CoreError> {
        return _delete
    }

    func insert(group: Group) -> SignalProducer<Group, CoreError> {
        return _insert
    }

    func update(group: Group) -> SignalProducer<Group, CoreError> {
        return _update
    }
}
