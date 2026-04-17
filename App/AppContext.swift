import Foundation

@MainActor
final class AppContext: ObservableObject {
    let repository: TransitRepository
    let locationService: LocationService

    init(repository: TransitRepository, locationService: LocationService) {
        self.repository = repository
        self.locationService = locationService
    }

    static func makeDefault() -> AppContext {
        let constants = AppConstants.production
        let gtfsService = GTFSService(config: constants)
        let csvService = CSVDataService(config: constants)
        let apiService = EshotAPIService(config: constants)
        let cacheService = CacheService()
        let repository = DefaultTransitRepository(
            gtfsService: gtfsService,
            csvService: csvService,
            apiService: apiService,
            cacheService: cacheService
        )
        return AppContext(repository: repository, locationService: LocationService())
    }
}
