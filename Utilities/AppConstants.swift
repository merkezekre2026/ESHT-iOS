import Foundation

struct AppConstants {
    let gtfsURL: URL
    let csvURLs: [CSVDataService.Dataset: URL]
    let apiEndpoints: APIEndpoints

    struct APIEndpoints {
        let approachingBusesByStop: URL?
        let approachingBusesByLineAndStop: URL?
        let vehicleLocationsByLine: URL?
        let nearbyStops: URL?
        let serviceAlerts: URL?
    }

    static let production = AppConstants(
        gtfsURL: URL(string: "https://www.eshot.gov.tr/gtfs/bus-eshot-gtfs.zip")!,
        csvURLs: [
            .lines: URL(string: "https://acikveri.bizizmir.com/dataset/otobus-hatlari/resource.csv")!,
            .routes: URL(string: "https://acikveri.bizizmir.com/dataset/otobus-hat-guzergahlari/resource.csv")!,
            .stops: URL(string: "https://acikveri.bizizmir.com/dataset/otobus-duraklari/resource.csv")!,
            .timetables: URL(string: "https://acikveri.bizizmir.com/dataset/otobus-hareket-saatleri/resource.csv")!
        ],
        apiEndpoints: .init(
            approachingBusesByStop: nil,
            approachingBusesByLineAndStop: nil,
            vehicleLocationsByLine: nil,
            nearbyStops: nil,
            serviceAlerts: nil
        )
    )
}
