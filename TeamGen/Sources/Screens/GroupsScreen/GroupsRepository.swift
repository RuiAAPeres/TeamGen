 import ReactiveSwift
 import enum Result.NoError

 protocol GroupsRepositoryProtocol {
    func groups() -> SignalProducer<[Group], CoreError>
    func group(withName name: String) -> SignalProducer<Group, CoreError>
    func make(group: Group) -> SignalProducer<Group, CoreError>
    func delete(group: Group) -> SignalProducer<Group, CoreError>
    func update(group: Group) -> SignalProducer<Group, CoreError>
 }

 struct GroupsRepository: GroupsRepositoryProtocol {

    func groups() -> SignalProducer<[Group], CoreError> {
        return .empty
    }

    func group(withName name: String) -> SignalProducer<Group, CoreError> {
        return .empty
    }

    func make(group: Group) -> SignalProducer<Group, CoreError> {
        return .empty
    }

    func delete(group: Group) -> SignalProducer<Group, CoreError> {
        return .empty
    }

    func update(group: Group) -> SignalProducer<Group, CoreError> {
        return .empty
    }
 }
