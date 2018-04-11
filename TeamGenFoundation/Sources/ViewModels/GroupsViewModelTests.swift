import XCTest
import Nimble
import Disk
import ReactiveSwift
@testable import TeamGenFoundation

class GroupsViewModelTests: XCTestCase {

    func test_StateMachine() {
        expect(GroupsViewModel.reducer(state: .loading, event: .groupsReady([]))).to(equal(GroupsViewModel.State.groupsReady([])))
        expect(GroupsViewModel.reducer(state: .loading, event: .viewIsReady)).to(equal(GroupsViewModel.State.loading))

        expect(GroupsViewModel.reducer(state: .groupsReady([]), event: .groupsReady([group1]))).to(equal(GroupsViewModel.State.groupsReady([group1])))
        expect(GroupsViewModel.reducer(state: .groupsReady([]), event: .viewIsReady)).to(equal(GroupsViewModel.State.loading))

        expect(GroupsViewModel.reducer(state: .loading, event: .groupsReady([group1]))).to(equal(GroupsViewModel.State.groupsReady([group1])))
        expect(GroupsViewModel.reducer(state: .loading, event: .viewIsReady)).to(equal(GroupsViewModel.State.loading))

        expect(GroupsViewModel.reducer(state: .groupsReady([]), event: .saveGroup(group1))).to(equal(GroupsViewModel.State.savingGroup(group1)))

        expect(GroupsViewModel.reducer(state: .savingGroup(group1), event: .reload)).to(equal(GroupsViewModel.State.loading))
    }

    func test_ViewModel_InitialState() {
        let stub = GroupsRepositoryStub()
        let viewModel = GroupsViewModel(groupsRepository: stub)

        expect(viewModel.viewLifecycle.value).to(equal(ViewLifeCycle.unknown))
        expect(viewModel.state.value).to(equal(GroupsViewModel.State.loading))
    }

    func test_ViewModel_FetchGroups_When_ViewDidLoad() {
        var stub = GroupsRepositoryStub()
        stub._groups = SignalProducer(value: [group1])

        let viewModel = GroupsViewModel(groupsRepository: stub)

        viewModel.viewLifecycle.value = .didLoad
        expect(viewModel.state.value).toEventually(equal(GroupsViewModel.State.groupsReady([group1])))
    }

    func test_ViewModel_NoFetching_When_ViewDidAppear() {
        var stub = GroupsRepositoryStub()
        stub._groups = SignalProducer(value: [group1])

        let viewModel = GroupsViewModel(groupsRepository: stub)

        viewModel.viewLifecycle.value = .didAppear
        expect(viewModel.state.value).toEventually(equal(GroupsViewModel.State.loading))
    }
}
