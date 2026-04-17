import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: HomeViewModel

    init() {
        _viewModel = StateObject(wrappedValue: HomeViewModel(repository: AppContext.makeDefault().repository))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 18) {
                Text("Eshot İzmir")
                    .font(.largeTitle.bold())
                Text("İzmir toplu ulaşımını canlı ve hızlı takip edin")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)

                if let date = viewModel.syncState.lastSyncDate {
                    StatusCard(title: "Son güncelleme", message: DateFormatter.turkishDateTime.string(from: date), icon: "arrow.clockwise")
                }

                LazyVGrid(columns: [GridItem(.flexible()), GridItem(.flexible())], spacing: 12) {
                    ForEach(viewModel.sections) { section in
                        NavigationLink(destination: destination(for: section.route)) {
                            StatusCard(title: section.title, message: "Hemen aç", icon: section.icon)
                        }
                        .buttonStyle(.plain)
                    }
                }

                if !viewModel.alerts.isEmpty {
                    Text("Duyurular")
                        .font(.title3.bold())
                    ForEach(viewModel.alerts) { alert in
                        StatusCard(title: alert.title, message: alert.message, icon: "megaphone")
                    }
                }
            }
            .padding()
        }
        .background(
            LinearGradient(colors: [.eshotPrimary.opacity(0.08), .clear], startPoint: .top, endPoint: .center)
        )
        .task { await viewModel.refresh() }
        .refreshable { await viewModel.refresh() }
    }

    @ViewBuilder
    private func destination(for route: HomeQuickSection.Route) -> some View {
        switch route {
        case .lines: LinesView()
        case .stops: StopsView()
        case .timetables: TimetablesView()
        case .nearby: NearbyStopsView()
        case .favorites: FavoritesView()
        }
    }
}

#Preview {
    NavigationStack { HomeView() }
        .environmentObject(AppContext.makeDefault())
}
