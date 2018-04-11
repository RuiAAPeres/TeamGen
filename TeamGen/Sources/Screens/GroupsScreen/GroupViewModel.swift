import TeamGenFoundation

enum GroupCellViewModel: Equatable {
    case group(GroupDigestViewModel)
    case addGroup(AddGroupViewModel)
    case loading
}

struct GroupDigestViewModel: Equatable {
    private let group: Group
    
    var title: String {
        return group.name
    }
    
    init(group: Group) {
        self.group = group
    }
}

struct AddGroupViewModel: Equatable {
    let title: String
}
