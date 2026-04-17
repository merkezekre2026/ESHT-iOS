import Foundation

@MainActor
final class LineDetailViewModel: ObservableObject {
    @Published var detail: LineDetail?
    @Published var selectedDirection = 0
    @Published var loading = false
    @Published var error: String?

    private let repository: TransitRepository
    private let lineID: String

    init(repository: TransitRepository, lineID: String) {
        self.repository = repository
        self.lineID = lineID
    }

    func load() async {
        loading = true
        defer { loading = false }
        do {
            detail = try await repository.lineDetail(lineID: lineID)
            error = nil
        } catch {
            error = "Hat detayı yüklenemedi."
        }
    }
}
