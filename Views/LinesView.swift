import SwiftUI

struct LinesView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: LinesViewModel

    init() {
        _viewModel = StateObject(wrappedValue: LinesViewModel(repository: AppContext.makeDefault().repository))
    }

    var body: some View {
        VStack(spacing: 12) {
            SearchField(text: $viewModel.query, placeholder: "Hat no veya başlık")
            Picker("Sırala", selection: $viewModel.sort) {
                ForEach(LinesViewModel.SortOption.allCases, id: \.self) { item in
                    Text(item.rawValue).tag(item)
                }
            }
            .pickerStyle(.segmented)

            if let error = viewModel.error {
                StatusCard(title: "Hata", message: error, icon: "exclamationmark.triangle")
            }

            List(viewModel.filtered) { line in
                NavigationLink(destination: LineDetailView(lineID: line.id)) {
                    LineCardView(line: line)
                        .listRowSeparator(.hidden)
                        .listRowBackground(Color.clear)
                }
            }
            .listStyle(.plain)
            .refreshable { await viewModel.load() }
        }
        .padding(.horizontal)
        .navigationTitle("Hatlar")
        .task { await viewModel.load() }
    }
}

#Preview {
    NavigationStack { LinesView() }
        .environmentObject(AppContext.makeDefault())
}
