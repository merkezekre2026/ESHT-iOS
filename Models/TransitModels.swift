import Foundation
import CoreLocation

struct Line: Identifiable, Hashable, Codable {
    let id: String
    let number: String
    let title: String
    let outboundName: String?
    let inboundName: String?
    let stopIDs: [String]
    let colorHex: String?
}

struct Stop: Identifiable, Hashable, Codable {
    let id: String
    let code: String
    let name: String
    let latitude: Double
    let longitude: Double
    let lineIDs: [String]

    var coordinate: CLLocationCoordinate2D {
        CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}

struct RouteShapePoint: Hashable, Codable {
    let shapeID: String
    let latitude: Double
    let longitude: Double
    let sequence: Int
}

struct Trip: Identifiable, Hashable, Codable {
    let id: String
    let lineID: String
    let directionID: Int
    let serviceID: String
    let shapeID: String?
    let headsign: String?
}

struct StopTime: Identifiable, Hashable, Codable {
    let id: String
    let tripID: String
    let stopID: String
    let arrivalTime: String
    let departureTime: String
    let sequence: Int
}

struct VehiclePosition: Identifiable, Hashable, Codable {
    let id: String
    let lineID: String
    let latitude: Double
    let longitude: Double
    let speed: Double?
    let heading: Double?
    let updatedAt: Date
}

struct ApproachingBus: Identifiable, Hashable, Codable {
    let id: String
    let stopID: String
    let lineID: String
    let destination: String
    let minutes: Int
    let plate: String?
}

struct ServiceAlert: Identifiable, Hashable, Codable {
    let id: String
    let title: String
    let message: String
    let startDate: Date?
    let endDate: Date?
}

struct TimetableEntry: Identifiable, Hashable, Codable {
    let id: String
    let lineID: String
    let stopID: String
    let dayType: DayType
    let departures: [String]

    enum DayType: String, Codable, CaseIterable {
        case weekday = "Hafta İçi"
        case saturday = "Cumartesi"
        case sunday = "Pazar"
    }
}

struct NearbyStop: Identifiable, Hashable {
    let id: String
    let stop: Stop
    let distanceMeters: Double
}
