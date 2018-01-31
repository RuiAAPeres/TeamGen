public struct GroupCellViewModel {
    private let group: Group
    private let select: (Group) -> Void

    init(group: Group, select: @escaping (Group) -> Void) {
        self.group = group
        self.select = select
    }

    public func didSelect() {
        select(group)
    }
}
