import SwiftUI
import MapKit

struct LineDetailView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: LineDetailViewModel

    init(lineID: String) {
        _viewModel = StateObject(wrappedValue: LineDetailViewModel(repository: AppContext.makeDefault().repository, lineID: lineID))
    }

    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 16) {
                if let detail = viewModel.detail {
                    Text("\(detail.line.number) • \(detail.line.title)")
                        .font(.title2.bold())

                    Picker("Yön", selection: $viewModel.selectedDirection) {
                        Text("Gidiş").tag(0)
                        Text("Dönüş").tag(1)
                    }
                    .pickerStyle(.segmented)

                    RouteMapPreview(stops: detail.stops, vehicles: detail.vehicles)
                        .frame(height: 240)

                    Text("Durak Akışı")
                        .font(.headline)
                    ForEach(detail.stops, id: \.id) { stop in
                        HStack {
                            Circle().fill(Color.eshotSecondary).frame(width: 8, height: 8)
                            Text(stop.name)
                            Spacer()
                        }
                        .padding(.vertical, 2)
                    }
                } else if viewModel.loading {
                    ProgressView("Yükleniyor")
                } else if let error = viewModel.error {
                    StatusCard(title: "Hata", message: error, icon: "exclamationmark.triangle")
                }
            }
            .padding()
        }
        .navigationTitle("Hat Detayı")
        .task { await viewModel.load() }
    }
}
