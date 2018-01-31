import XCTest
import Nimble
import Disk
import ReactiveSwift
@testable import TeamGenFoundation

class GroupsViewModelTests: XCTestCase {

    func test_StateMachine() {
        expect(GroupsViewModel.reducer(state: .initial, event: .loaded([]))).to(equal(GroupsViewModel.State.loaded([])))
        expect(GroupsViewModel.reducer(state: .initial, event: .viewIsReady)).to(equal(GroupsViewModel.State.loading))

        expect(GroupsViewModel.reducer(state: .loaded([]), event: .loaded([group1]))).to(equal(GroupsViewModel.State.loaded([group1])))
        expect(GroupsViewModel.reducer(state: .loaded([]), event: .viewIsReady)).to(equal(GroupsViewModel.State.loading))

        expect(GroupsViewModel.reducer(state: .loading, event: .loaded([group1]))).to(equal(GroupsViewModel.State.loaded([group1])))
        expect(GroupsViewModel.reducer(state: .loading, event: .viewIsReady)).to(equal(GroupsViewModel.State.loading))
    }

    func test_ViewModel_InitialState() {
        let stub = GroupsRepositoryStub()
        let viewModel = GroupsViewModel(groupsReposiotry: stub)

        expect(viewModel.viewLifecycle.value).to(equal(ViewLifeCycle.unknown))
        expect(viewModel.state.value).to(equal(GroupsViewModel.State.initial))
    }

    func test_ViewModel_FetchGroups_When_ViewDidLoad() {
        var stub = GroupsRepositoryStub()
        stub._groups = SignalProducer(value: [group1])

        let viewModel = GroupsViewModel(groupsReposiotry: stub)

        viewModel.viewLifecycle.value = .didLoad
        expect(viewModel.state.value).toEventually(equal(GroupsViewModel.State.loaded([group1])))
    }

    func test_ViewModel_NoFetching_When_ViewDidAppear() {
        var stub = GroupsRepositoryStub()
        stub._groups = SignalProducer(value: [group1])

        let viewModel = GroupsViewModel(groupsReposiotry: stub)

        viewModel.viewLifecycle.value = .didAppear
        expect(viewModel.state.value).toEventually(equal(GroupsViewModel.State.initial))
    }
}
