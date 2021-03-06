 import ReactiveSwift
 import Result
 import Disk

 public protocol GroupsRepositoryProtocol {
    func groups() -> SignalProducer<[Group], CoreError>
    func group(withName name: String) -> SignalProducer<Group, CoreError>
    func delete(withName name: String) -> SignalProducer<Void, CoreError>
    func insert(group: Group) -> SignalProducer<Group, CoreError>
    func update(group: Group) -> SignalProducer<Group, CoreError>
 }

 public struct GroupsRepository: GroupsRepositoryProtocol {

    private let filename: String
    private let queue = QueueScheduler()

    public init(filename: String = "groups.json") {
        self.filename = filename
    }

    public func groups() -> SignalProducer<[Group], CoreError> {
        return SignalProducer {[filename] o, _ in
            do {
                let group = try Disk.retrieve(filename, from: .applicationSupport, as: [Group].self)
                o.send(value: group)
                o.sendCompleted()
            }
            catch let error as NSError where error.domain == "DiskErrorDomain"  {
                try? Disk.save([] as [Group], to: .applicationSupport, as: filename)
                o.send(value: [])
                o.sendCompleted()
            }
            catch {
                o.send(error: CoreError.reading("Couldn't find any group"))
            }
            }
            .start(on: queue)
    }

    public func group(withName name: String) -> SignalProducer<Group, CoreError> {
        func findGroup(groups: [Group]) -> SignalProducer<Group, CoreError> {
            let filter: (Group) -> Bool = { $0.name == name }

            guard let group = groups.filter(filter).first else {
                return SignalProducer(error: CoreError.reading("\(name) not found"))
            }

            return SignalProducer(value: group)
        }

        return groups()
            .flatMap(.latest, findGroup)
            .start(on: queue)
    }

    public func insert(group: Group) -> SignalProducer<Group, CoreError> {
        let alreadyExists: ([Group]) -> SignalProducer<[Group], CoreError> = { groups in
            guard groups.contains(group) == false else { return SignalProducer(error: CoreError.inserting("Already exists")) }
            return SignalProducer(value: groups)
        }

        let sanityCheck: (Group) -> SignalProducer<Group, CoreError> = { group in
            let isValid = GroupsRepository.areSkillsValid_sanityCheck(group: group)
            return isValid ? SignalProducer(value: group) : SignalProducer(error: CoreError.inserting("Invalid group"))
        }

        return
            SignalProducer(value: group)
                .flatMap(.latest, sanityCheck)
                .combineLatest(with: self.groups().flatMap(.latest, alreadyExists))
                .map { return $0.1 + [$0.0] }
                .flatMap(.latest, saveGroups)
                .then(SignalProducer(value: group))
                .start(on: queue)
    }

    public func delete(withName name: String) -> SignalProducer<Void, CoreError> {

        func removeGroup(groups: [Group]) -> [Group] {
            let filter: (Group) -> Bool = { $0.name != name }
            return groups.filter(filter)
        }

        return groups()
            .map(removeGroup)
            .flatMap(.latest, saveGroups)
            .map { _ in }
            .start(on: queue)
    }

    public func update(group: Group) -> SignalProducer<Group, CoreError> {
        return delete(withName: group.name)
            .then(insert(group: group))
            .start(on: queue)
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
                o.send(error: CoreError.inserting("save groups failed"))
            }
        }
    }
 }

 extension GroupsRepository {
    static fileprivate func areSkillsValid_sanityCheck(group: Group) -> Bool {
        let skillSpecs = group.skillSpec
        let players = group.players

        let reducer: (Bool, Player) -> Bool = { isValid, player in
            let playerSkillSpecs = player.skills.compactMap { $0.spec }
            return isValid && playerSkillSpecs == skillSpecs
        }

        return players.reduce(true, reducer)
    }
 }
