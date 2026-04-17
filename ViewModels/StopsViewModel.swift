import Foundation

@MainActor
final class StopsViewModel: ObservableObject {
    @Published var query = ""
    @Published var stops: [Stop] = []
    @Published var error: String?

    private let repository: TransitRepository

    init(repository: TransitRepository) {
        self.repository = repository
    }

    var filtered: [Stop] {
        query.isEmpty ? stops : stops.filter { $0.name.localizedCaseInsensitiveContains(query) || $0.code.localizedCaseInsensitiveContains(query) }
    }

    func load() async {
        do {
            stops = try await repository.stops()
        } catch {
            error = "Duraklar yüklenemedi."
        }
    }
}
