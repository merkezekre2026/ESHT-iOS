import Foundation

@MainActor
final class StopDetailViewModel: ObservableObject {
    @Published var detail: StopDetail?
    @Published var error: String?

    private let repository: TransitRepository
    private let stopID: String

    init(repository: TransitRepository, stopID: String) {
        self.repository = repository
        self.stopID = stopID
    }

    func load() async {
        do {
            detail = try await repository.stopDetail(stopID: stopID)
        } catch {
            error = "Durak bilgisi alınamadı."
        }
    }
}
