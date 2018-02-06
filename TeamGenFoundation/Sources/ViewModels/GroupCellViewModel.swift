public protocol GroupCellViewModelRepresentable {
    func selectGroup()
}

public struct GroupCellViewModel: GroupCellViewModelRepresentable {
    private let group: Group
    private let select: (Group) -> Void

    init(group: Group, select: @escaping (Group) -> Void) {
        self.group = group
        self.select = select
    }

    public func selectGroup() {
        select(group)
    }
}

extension GroupCellViewModel: Equatable {
    public static func ==(lhs: GroupCellViewModel, rhs: GroupCellViewModel) -> Bool {
        return lhs.group == rhs.group
    }
}
