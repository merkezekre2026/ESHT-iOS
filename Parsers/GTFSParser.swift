import Foundation

struct GTFSParser {
    private let csvParser = CSVParser()

    func parseRoutes(_ content: String) -> [GTFSRoute] {
        csvParser.parseRows(content).compactMap { row in
            guard let routeID = row["route_id"], let short = row["route_short_name"], let long = row["route_long_name"] else { return nil }
            return GTFSRoute(routeID: routeID, routeShortName: short, routeLongName: long, routeColor: row["route_color"])
        }
    }

    func parseStops(_ content: String) -> [GTFSStop] {
        csvParser.parseRows(content).compactMap { row in
            guard
                let stopID = row["stop_id"],
                let stopName = row["stop_name"],
                let lat = row["stop_lat"].flatMap(Double.init),
                let lon = row["stop_lon"].flatMap(Double.init)
            else { return nil }

            return GTFSStop(stopID: stopID, stopCode: row["stop_code"], stopName: stopName, stopLat: lat, stopLon: lon)
        }
    }

    func parseTrips(_ content: String) -> [GTFSTrip] {
        csvParser.parseRows(content).compactMap { row in
            guard let routeID = row["route_id"], let serviceID = row["service_id"], let tripID = row["trip_id"] else { return nil }
            return GTFSTrip(
                routeID: routeID,
                serviceID: serviceID,
                tripID: tripID,
                tripHeadsign: row["trip_headsign"],
                directionID: row["direction_id"].flatMap(Int.init),
                shapeID: row["shape_id"]
            )
        }
    }

    func parseStopTimes(_ content: String) -> [GTFSStopTime] {
        csvParser.parseRows(content).compactMap { row in
            guard
                let tripID = row["trip_id"],
                let arrival = row["arrival_time"],
                let departure = row["departure_time"],
                let stopID = row["stop_id"],
                let sequence = row["stop_sequence"].flatMap(Int.init)
            else { return nil }

            return GTFSStopTime(tripID: tripID, arrivalTime: arrival, departureTime: departure, stopID: stopID, stopSequence: sequence)
        }
    }

    func parseShapes(_ content: String) -> [GTFSShape] {
        csvParser.parseRows(content).compactMap { row in
            guard
                let shapeID = row["shape_id"],
                let lat = row["shape_pt_lat"].flatMap(Double.init),
                let lon = row["shape_pt_lon"].flatMap(Double.init),
                let seq = row["shape_pt_sequence"].flatMap(Int.init)
            else { return nil }
            return GTFSShape(shapeID: shapeID, shapePtLat: lat, shapePtLon: lon, shapePtSequence: seq)
        }
    }
}
