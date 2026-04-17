import Foundation
import CoreLocation

actor DefaultTransitRepository: TransitRepository {
    private let gtfsService: GTFSService
    private let csvService: CSVDataService
    private let apiService: EshotAPIService
    private let cacheService: CacheService

    private var linesStore: [Line] = []
    private var stopsStore: [Stop] = []
    private var tripsStore: [Trip] = []
    private var stopTimesStore: [StopTime] = []
    private var shapesStore: [RouteShapePoint] = []

    init(gtfsService: GTFSService, csvService: CSVDataService, apiService: EshotAPIService, cacheService: CacheService) {
        self.gtfsService = gtfsService
        self.csvService = csvService
        self.apiService = apiService
        self.cacheService = cacheService
    }

    func refreshAll() async throws -> Date {
        do {
            let gtfs = try await gtfsService.fetchAndParse()
            try await mergeData(gtfs: gtfs)

            try cacheService.write(linesStore, key: "lines")
            try cacheService.write(stopsStore, key: "stops")
            return Date()
        } catch {
            if let cachedLines = try? cacheService.read([Line].self, key: "lines"),
               let cachedStops = try? cacheService.read([Stop].self, key: "stops") {
                linesStore = cachedLines
                stopsStore = cachedStops
                return Date()
            }
            throw error
        }
    }

    func lines() async throws -> [Line] {
        if linesStore.isEmpty { _ = try await refreshAll() }
        return linesStore.sorted { $0.number < $1.number }
    }

    func stops() async throws -> [Stop] {
        if stopsStore.isEmpty { _ = try await refreshAll() }
        return stopsStore
    }

    func lineDetail(lineID: String) async throws -> LineDetail {
        if linesStore.isEmpty { _ = try await refreshAll() }
        guard let line = linesStore.first(where: { $0.id == lineID }) else { throw URLError(.fileDoesNotExist) }
        let stops = stopsStore.filter { line.stopIDs.contains($0.id) }
        let trips = tripsStore.filter { $0.lineID == lineID }
        let shapeIDs = Set(trips.compactMap(\.shapeID))
        let shapes = shapesStore.filter { shapeIDs.contains($0.shapeID) }
        let vehicles = (try? await apiService.vehicleLocations(lineID: lineID)) ?? []
        return LineDetail(line: line, stops: stops, shapePoints: shapes, trips: trips, vehicles: vehicles)
    }

    func stopDetail(stopID: String) async throws -> StopDetail {
        if stopsStore.isEmpty { _ = try await refreshAll() }
        guard let stop = stopsStore.first(where: { $0.id == stopID }) else { throw URLError(.fileDoesNotExist) }
        let lines = linesStore.filter { stop.lineIDs.contains($0.id) }
        let approaching = (try? await apiService.approachingBuses(stopID: stopID)) ?? []

        let departures = stopTimesStore
            .filter { $0.stopID == stopID }
            .map(\.departureTime)
            .sorted()
            .prefix(8)

        return StopDetail(stop: stop, lines: lines, approachingBuses: approaching, nextDepartures: Array(departures))
    }

    func timetables(lineID: String?) async throws -> [TimetableEntry] {
        if stopsStore.isEmpty { _ = try await refreshAll() }
        let filteredTrips = tripsStore.filter { lineID == nil || $0.lineID == lineID }
        let tripIDs = Set(filteredTrips.map(\.id))

        let grouped = Dictionary(grouping: stopTimesStore.filter { tripIDs.contains($0.tripID) }) { $0.stopID }

        return grouped.map { stopID, stopTimes in
            TimetableEntry(
                id: "\(lineID ?? "all")-\(stopID)",
                lineID: lineID ?? "Tümü",
                stopID: stopID,
                dayType: .weekday,
                departures: stopTimes.map(\.departureTime).sorted()
            )
        }
    }

    func nearbyStops(location: CLLocation) async throws -> [NearbyStop] {
        let stops = try await self.stops()
        let apiStops = (try? await apiService.nearbyStops(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)) ?? []
        let source = apiStops.isEmpty ? stops : apiStops

        return source
            .map { stop in
                let stopLoc = CLLocation(latitude: stop.latitude, longitude: stop.longitude)
                return NearbyStop(id: stop.id, stop: stop, distanceMeters: location.distance(from: stopLoc))
            }
            .sorted { $0.distanceMeters < $1.distanceMeters }
            .prefix(20)
            .map { $0 }
    }

    func serviceAlerts() async throws -> [ServiceAlert] {
        (try? await apiService.serviceAlerts()) ?? []
    }

    private func mergeData(gtfs: GTFSPayload) async throws {
        let csvLines = try? await csvService.fetch(dataset: .lines)
        let csvRoutes = try? await csvService.fetch(dataset: .routes)

        linesStore = gtfs.routes.map { route in
            let csvLine = csvLines?.first(where: { $0["hat_no"] == route.routeShortName })
            let outbound = csvRoutes?.first(where: { $0["hat_no"] == route.routeShortName })?["gidis"]
            let inbound = csvRoutes?.first(where: { $0["hat_no"] == route.routeShortName })?["donus"]

            return Line(
                id: route.routeID,
                number: route.routeShortName,
                title: csvLine?["hat_adi"] ?? route.routeLongName,
                outboundName: outbound,
                inboundName: inbound,
                stopIDs: [],
                colorHex: route.routeColor
            )
        }

        let tripMap = Dictionary(grouping: gtfs.trips, by: { $0.routeID })

        tripsStore = gtfs.trips.map {
            Trip(id: $0.tripID, lineID: $0.routeID, directionID: $0.directionID ?? 0, serviceID: $0.serviceID, shapeID: $0.shapeID, headsign: $0.tripHeadsign)
        }

        stopTimesStore = gtfs.stopTimes.map {
            StopTime(id: "\($0.tripID)-\($0.stopSequence)", tripID: $0.tripID, stopID: $0.stopID, arrivalTime: $0.arrivalTime, departureTime: $0.departureTime, sequence: $0.stopSequence)
        }

        shapesStore = gtfs.shapes.map {
            RouteShapePoint(shapeID: $0.shapeID, latitude: $0.shapePtLat, longitude: $0.shapePtLon, sequence: $0.shapePtSequence)
        }

        let tripStopMap = Dictionary(grouping: gtfs.stopTimes, by: { $0.stopID })

        stopsStore = gtfs.stops.map { stop in
            let lineIDs = Set((tripStopMap[stop.stopID] ?? []).compactMap { st in
                gtfs.trips.first(where: { $0.tripID == st.tripID })?.routeID
            })

            return Stop(
                id: stop.stopID,
                code: stop.stopCode ?? stop.stopID,
                name: stop.stopName,
                latitude: stop.stopLat,
                longitude: stop.stopLon,
                lineIDs: Array(lineIDs)
            )
        }

        linesStore = linesStore.map { line in
            var mutable = line
            let ids = tripMap[line.id]?.compactMap { trip in
                stopTimesStore.filter { $0.tripID == trip.tripID }.sorted { $0.sequence < $1.sequence }.map(\.stopID)
            }.flatMap { $0 } ?? []
            return Line(
                id: mutable.id,
                number: mutable.number,
                title: mutable.title,
                outboundName: mutable.outboundName,
                inboundName: mutable.inboundName,
                stopIDs: Array(Set(ids)),
                colorHex: mutable.colorHex
            )
        }
    }
}
