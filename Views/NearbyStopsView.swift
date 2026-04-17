import SwiftUI

struct NearbyStopsView: View {
    @EnvironmentObject private var appContext: AppContext
    @StateObject private var viewModel: NearbyStopsViewModel

    init() {
        _viewModel = StateObject(wrappedValue: NearbyStopsViewModel(repository: AppContext.makeDefault().repository))
    }

    var body: some View {
        List(viewModel.nearbyStops) { item in
            VStack(alignment: .leading, spacing: 6) {
                Text(item.stop.name).font(.headline)
                Text("\(Int(item.distanceMeters)) metre")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .navigationTitle("Yakındaki Duraklar")
        .task {
            appContext.locationService.requestAuthorization()
            appContext.locationService.requestLocation()
            await viewModel.load(location: appContext.locationService.currentLocation)
        }
    }
}
