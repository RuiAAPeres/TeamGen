import XCTest
import Nimble
import Disk
import ReactiveSwift
@testable import TeamGenFoundation

class GroupsScreenViewModelTests: XCTestCase {

    func test_StateMachine() {
        expect(GroupsScreenViewModel.reducer(state: .initial, event: .loaded([]))).to(equal(GroupsScreenViewModel.State.loaded([])))
        expect(GroupsScreenViewModel.reducer(state: .initial, event: .viewIsReady)).to(equal(GroupsScreenViewModel.State.loading))

        expect(GroupsScreenViewModel.reducer(state: .loaded([]), event: .loaded([group1]))).to(equal(GroupsScreenViewModel.State.loaded([group1])))
        expect(GroupsScreenViewModel.reducer(state: .loaded([]), event: .viewIsReady)).to(equal(GroupsScreenViewModel.State.loading))

        expect(GroupsScreenViewModel.reducer(state: .loading, event: .loaded([group1]))).to(equal(GroupsScreenViewModel.State.loaded([group1])))
        expect(GroupsScreenViewModel.reducer(state: .loading, event: .viewIsReady)).to(equal(GroupsScreenViewModel.State.loading))
    }

    func test_ViewModel_InitialState() {
        let stub = GroupsRepositoryStub()
        let viewModel = GroupsScreenViewModel(groupsReposiotry: stub)

        expect(viewModel.viewLifecycle.value).to(equal(ViewLifeCycle.unknown))
        expect(viewModel.state.value).to(equal(GroupsScreenViewModel.State.initial))
    }

    func test_ViewModel_FetchGroups_When_ViewDidLoad() {
        var stub = GroupsRepositoryStub()
        stub._groups = SignalProducer(value: [group1])

        let viewModel = GroupsScreenViewModel(groupsReposiotry: stub)

        viewModel.viewLifecycle.value = .didLoad
        expect(viewModel.state.value).toEventually(equal(GroupsScreenViewModel.State.loaded([group1])))
    }

    func test_ViewModel_NoFetching_When_ViewDidAppear() {
        var stub = GroupsRepositoryStub()
        stub._groups = SignalProducer(value: [group1])

        let viewModel = GroupsScreenViewModel(groupsReposiotry: stub)

        viewModel.viewLifecycle.value = .didAppear
        expect(viewModel.state.value).toEventually(equal(GroupsScreenViewModel.State.initial))
    }
}
