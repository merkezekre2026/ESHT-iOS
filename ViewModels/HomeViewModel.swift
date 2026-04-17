import Foundation

@MainActor
final class HomeViewModel: ObservableObject {
    @Published var syncState = SyncState()
    @Published var alerts: [ServiceAlert] = []

    let sections: [HomeQuickSection] = [
        .init(title: "Hatlar", icon: "point.topleft.down.curvedto.point.bottomright.up", route: .lines),
        .init(title: "Duraklar", icon: "mappin", route: .stops),
        .init(title: "Saatler", icon: "clock", route: .timetables),
        .init(title: "Yakındaki Duraklar", icon: "location", route: .nearby),
        .init(title: "Favoriler", icon: "star", route: .favorites)
    ]

    private let repository: TransitRepository

    init(repository: TransitRepository) {
        self.repository = repository
    }

    func refresh() async {
        syncState.isLoading = true
        syncState.errorMessage = nil
        do {
            syncState.lastSyncDate = try await repository.refreshAll()
            alerts = try await repository.serviceAlerts()
        } catch {
            syncState.errorMessage = "Veri güncellenemedi. Lütfen tekrar deneyin."
        }
        syncState.isLoading = false
    }
}
