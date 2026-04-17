import Foundation

final class EshotAPIService {
    private let config: AppConstants
    private let network: NetworkServing

    init(config: AppConstants, network: NetworkServing = NetworkService()) {
        self.config = config
        self.network = network
    }

    func approachingBuses(stopID: String) async throws -> [ApproachingBus] {
        guard let endpoint = config.apiEndpoints.approachingBusesByStop else { return [] }
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [.init(name: "stopId", value: stopID)]
        guard let url = components?.url else { return [] }

        let data = try await network.data(from: url)
        return try JSONDecoder().decode([ApproachingBus].self, from: data)
    }

    func vehicleLocations(lineID: String) async throws -> [VehiclePosition] {
        guard let endpoint = config.apiEndpoints.vehicleLocationsByLine else { return [] }
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [.init(name: "lineId", value: lineID)]
        guard let url = components?.url else { return [] }

        let data = try await network.data(from: url)
        return try JSONDecoder().decode([VehiclePosition].self, from: data)
    }

    func nearbyStops(latitude: Double, longitude: Double) async throws -> [Stop] {
        guard let endpoint = config.apiEndpoints.nearbyStops else { return [] }
        var components = URLComponents(url: endpoint, resolvingAgainstBaseURL: false)
        components?.queryItems = [
            .init(name: "lat", value: String(latitude)),
            .init(name: "lon", value: String(longitude))
        ]
        guard let url = components?.url else { return [] }

        let data = try await network.data(from: url)
        return try JSONDecoder().decode([Stop].self, from: data)
    }

    func serviceAlerts() async throws -> [ServiceAlert] {
        guard let endpoint = config.apiEndpoints.serviceAlerts else { return [] }
        let data = try await network.data(from: endpoint)
        return try JSONDecoder().decode([ServiceAlert].self, from: data)
    }
}
