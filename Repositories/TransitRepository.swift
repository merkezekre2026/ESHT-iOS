import Foundation
import CoreLocation

protocol TransitRepository {
    func refreshAll() async throws -> Date
    func lines() async throws -> [Line]
    func stops() async throws -> [Stop]
    func lineDetail(lineID: String) async throws -> LineDetail
    func stopDetail(stopID: String) async throws -> StopDetail
    func timetables(lineID: String?) async throws -> [TimetableEntry]
    func nearbyStops(location: CLLocation) async throws -> [NearbyStop]
    func serviceAlerts() async throws -> [ServiceAlert]
}

struct LineDetail {
    let line: Line
    let stops: [Stop]
    let shapePoints: [RouteShapePoint]
    let trips: [Trip]
    let vehicles: [VehiclePosition]
}

struct StopDetail {
    let stop: Stop
    let lines: [Line]
    let approachingBuses: [ApproachingBus]
    let nextDepartures: [String]
}
