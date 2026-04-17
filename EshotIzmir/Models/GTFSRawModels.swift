import Foundation

struct GTFSRoute: Decodable {
    let routeID: String
    let routeShortName: String
    let routeLongName: String
    let routeColor: String?

    enum CodingKeys: String, CodingKey {
        case routeID = "route_id"
        case routeShortName = "route_short_name"
        case routeLongName = "route_long_name"
        case routeColor = "route_color"
    }
}

struct GTFSStop: Decodable {
    let stopID: String
    let stopCode: String?
    let stopName: String
    let stopLat: Double
    let stopLon: Double

    enum CodingKeys: String, CodingKey {
        case stopID = "stop_id"
        case stopCode = "stop_code"
        case stopName = "stop_name"
        case stopLat = "stop_lat"
        case stopLon = "stop_lon"
    }
}

struct GTFSTrip: Decodable {
    let routeID: String
    let serviceID: String
    let tripID: String
    let tripHeadsign: String?
    let directionID: Int?
    let shapeID: String?

    enum CodingKeys: String, CodingKey {
        case routeID = "route_id"
        case serviceID = "service_id"
        case tripID = "trip_id"
        case tripHeadsign = "trip_headsign"
        case directionID = "direction_id"
        case shapeID = "shape_id"
    }
}

struct GTFSStopTime: Decodable {
    let tripID: String
    let arrivalTime: String
    let departureTime: String
    let stopID: String
    let stopSequence: Int

    enum CodingKeys: String, CodingKey {
        case tripID = "trip_id"
        case arrivalTime = "arrival_time"
        case departureTime = "departure_time"
        case stopID = "stop_id"
        case stopSequence = "stop_sequence"
    }
}

struct GTFSShape: Decodable {
    let shapeID: String
    let shapePtLat: Double
    let shapePtLon: Double
    let shapePtSequence: Int

    enum CodingKeys: String, CodingKey {
        case shapeID = "shape_id"
        case shapePtLat = "shape_pt_lat"
        case shapePtLon = "shape_pt_lon"
        case shapePtSequence = "shape_pt_sequence"
    }
}
