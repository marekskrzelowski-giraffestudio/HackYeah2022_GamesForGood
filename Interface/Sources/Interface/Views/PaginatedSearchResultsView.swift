import SwiftUI

struct PaginatedSearchResultsView<ViewModel: PaginatedSearchResultsViewModel, Content: View, Placeholder: View>: View {
    @StateObject var viewModel: ViewModel
    let content: (ViewModel.Presentable) -> Content
    let placeholder: Placeholder
    let bottomPadding: CGFloat
    let topPadding: CGFloat

    var body: some View {
        Group {
            switch viewModel.state {
            case .placeholder:
                placeholder
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .padding(.horizontal, 48)
            case let .list(presentables, reachedEnd):
                list(for: presentables, reachedEnd: reachedEnd)
            }
        }
        .onLoad {
            Task {
                await viewModel.search()
            }
        }
    }

    private func list(for presentables: [ViewModel.Presentable], reachedEnd: Bool) -> some View {
        ScrollView(showsIndicators: false) {
            LazyVStack {
                ForEach(presentables, content: content)
                if !reachedEnd {
                    ProgressView()
                        .padding()
                        .task { await viewModel.fetchMore() }
                }
            }
            .padding(.bottom, bottomPadding)
            .padding(.top, topPadding)
        }
    }
}

@MainActor protocol PaginatedSearchResultsViewModel: ObservableObject {
    associatedtype Presentable: Identifiable
    var state: PaginatedSearchResultsState<Presentable> { get set }
    var pageSize: Int { get }
    var currentPage: Int { get set }
    var searchText: String { get }
    var searchTextPublisher: Published<String>.Publisher { get }
    func search(query: String, currentPage: Int, size: Int) async -> [Presentable]
}

enum PaginatedSearchResultsState<Presentable: Identifiable> {
    case placeholder
    case list(presentables: [Presentable], reachedEnd: Bool)
}

private extension PaginatedSearchResultsViewModel {
    func search() async {
        let values = searchTextPublisher
            .debounce(for: 0.5, scheduler: DispatchQueue.main)
            .values
        for await value in values {
            currentPage = 1
            let presentables = await search(query: value, currentPage: currentPage, size: pageSize)
            let reachedEnd = presentables.count < pageSize
            state = presentables.isEmpty ? .placeholder : .list(presentables: presentables, reachedEnd: reachedEnd)
        }
    }

    func fetchMore() async {
        currentPage += 1
        var presentables = await search(query: searchText, currentPage: currentPage, size: pageSize)
        let reachedEnd = presentables.count < pageSize
        if case let .list(currentPresentables, _) = state {
            presentables = currentPresentables + presentables
        }
        state = presentables.isEmpty ? .placeholder : .list(presentables: presentables, reachedEnd: reachedEnd)
    }
}
