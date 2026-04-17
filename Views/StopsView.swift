import SwiftUI

struct StopsView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: StopsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: StopsViewModel(repository: AppContext.makeDefault().repository))
    }

    var body: some View {
        VStack {
            SearchField(text: $viewModel.query, placeholder: "Durak adı veya kod")
                .padding(.horizontal)

            List(viewModel.filtered) { stop in
                NavigationLink(destination: StopDetailView(stopID: stop.id)) {
                    StopCardView(stop: stop)
                }
                .listRowSeparator(.hidden)
                .listRowBackground(Color.clear)
            }
            .listStyle(.plain)
        }
        .navigationTitle("Duraklar")
        .task { await viewModel.load() }
    }
}
