 import ReactiveSwift
 import Result
 import Disk

 protocol GroupsRepositoryProtocol {
    func groups() -> SignalProducer<[Group], CoreError>
    func group(withName name: String) -> SignalProducer<Group, CoreError>
    func delete(withName name: String) -> SignalProducer<Group, CoreError>
    func make(group: Group) -> SignalProducer<Group, CoreError>
    func update(group: Group) -> SignalProducer<Group, CoreError>
 }

 struct GroupsRepository: GroupsRepositoryProtocol {

    private let filename: String

    init(filename: String = "groups.json") {
        self.filename = filename
    }

    func groups() -> SignalProducer<[Group], CoreError> {
        return SignalProducer {[filename] o, _ in
            do {
                let group = try Disk.retrieve(filename, from: .applicationSupport, as: [Group].self)
                o.send(value: group)
                o.sendCompleted()
            }
            catch {
                o.send(error: CoreError.reading("Couldn't find any group"))
            }
        }
    }

    func group(withName name: String) -> SignalProducer<Group, CoreError> {
        
        func findGroup(groups: [Group]) -> SignalProducer<Group, CoreError> {
            let filter: (Group) -> Bool = { $0.name == name }

            guard let group = groups.filter(filter).first else {
                return SignalProducer(error: CoreError.reading("Couldn't find group \(name)"))
            }

            return SignalProducer(value: group)
        }

        return groups().flatMap(.latest, findGroup)
    }

    func make(group: Group) -> SignalProducer<Group, CoreError> {
        return .empty
        //        return groups().flatMap(.latest, createGroup)
    }

    func delete(withName name: String) -> SignalProducer<Group, CoreError> {

        func removeGroup(groups: [Group]) -> [Group] {
            let filter: (Group) -> Bool = { $0.name != name }
            return groups.filter(filter)
        }

        return groups()
            .map(removeGroup)
            .flatMap(.latest, saveGroups)
    }

    func update(group: Group) -> SignalProducer<Group, CoreError> {
        return .empty
    }
 }

 extension GroupsRepository {
    private func saveGroups(groups: [Group]) -> SignalProducer<[Group], CoreError> {
        return SignalProducer {[filename] o, _ in
            do {
                try Disk.save(groups, to: .applicationSupport, as: filename)
                o.send(value: groups)
                o.sendCompleted()
            }
            catch {
                o.send(error: CoreError.inserting("Couldn't save groups"))
            }
        }
    }
 }
