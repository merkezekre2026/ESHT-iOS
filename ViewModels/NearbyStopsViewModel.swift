import Foundation
import CoreLocation

@MainActor
final class NearbyStopsViewModel: ObservableObject {
    @Published var nearbyStops: [NearbyStop] = []
    @Published var error: String?

    private let repository: TransitRepository

    init(repository: TransitRepository) {
        self.repository = repository
    }

    func load(location: CLLocation?) async {
        guard let location else {
            error = "Konum izni bekleniyor."
            return
        }

        do {
            nearbyStops = try await repository.nearbyStops(location: location)
        } catch {
            error = "Yakındaki duraklar getirilemedi."
        }
    }
}
