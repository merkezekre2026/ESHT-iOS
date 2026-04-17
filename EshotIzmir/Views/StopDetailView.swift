import SwiftUI
import MapKit

struct StopDetailView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: StopDetailViewModel

    init(stopID: String) {
        _viewModel = StateObject(wrappedValue: StopDetailViewModel(repository: AppContext.makeDefault().repository, stopID: stopID))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = viewModel.detail {
                    Text(detail.stop.name)
                        .font(.title3.bold())
                    Text("Durak Kodu: \(detail.stop.code)")
                        .foregroundStyle(.secondary)

                    RouteMapPreview(stops: [detail.stop], vehicles: [])
                        .frame(height: 220)

                    Text("Yaklaşan Otobüsler")
                        .font(.headline)
                    if detail.approachingBuses.isEmpty {
                        Text("Canlı veri şu anda yok.")
                            .foregroundStyle(.secondary)
                    } else {
                        ForEach(detail.approachingBuses) { bus in
                            StatusCard(title: bus.lineID, message: "\(bus.destination) • \(bus.minutes) dk", icon: "bus.fill")
                        }
                    }

                    Text("Sonraki Kalkışlar")
                        .font(.headline)
                    ForEach(detail.nextDepartures, id: \.self) { departure in
                        Text(departure).font(.body.monospacedDigit())
                    }
                } else {
                    ProgressView("Yükleniyor")
                }
            }
            .padding()
        }
        .navigationTitle("Durak Detayı")
        .task { await viewModel.load() }
    }
}
