import Foundation

struct GTFSPayload {
    let routes: [GTFSRoute]
    let stops: [GTFSStop]
    let trips: [GTFSTrip]
    let stopTimes: [GTFSStopTime]
    let shapes: [GTFSShape]
}

final class GTFSService {
    private let config: AppConstants
    private let network: NetworkServing
    private let parser = GTFSParser()

    init(config: AppConstants, network: NetworkServing = NetworkService()) {
        self.config = config
        self.network = network
    }

    func fetchAndParse() async throws -> GTFSPayload {
        let zipData = try await network.data(from: config.gtfsURL)
        let files = try GTFSZipExtractor().extractCSVFiles(zipData: zipData)

        let routes = parser.parseRoutes(files["routes.txt"] ?? "")
        let stops = parser.parseStops(files["stops.txt"] ?? "")
        let trips = parser.parseTrips(files["trips.txt"] ?? "")
        let stopTimes = parser.parseStopTimes(files["stop_times.txt"] ?? "")
        let shapes = parser.parseShapes(files["shapes.txt"] ?? "")

        return GTFSPayload(routes: routes, stops: stops, trips: trips, stopTimes: stopTimes, shapes: shapes)
    }
}
