import Foundation

@MainActor
final class LinesViewModel: ObservableObject {
    @Published var query = ""
    @Published var lines: [Line] = []
    @Published var loading = false
    @Published var error: String?

    enum SortOption: String, CaseIterable {
        case lineNo = "Hat No"
        case title = "Başlık"
    }

    @Published var sort: SortOption = .lineNo

    private let repository: TransitRepository

    init(repository: TransitRepository) {
        self.repository = repository
    }

    var filtered: [Line] {
        let base = query.isEmpty ? lines : lines.filter { $0.number.localizedCaseInsensitiveContains(query) || $0.title.localizedCaseInsensitiveContains(query) }
        switch sort {
        case .lineNo: return base.sorted { $0.number < $1.number }
        case .title: return base.sorted { $0.title < $1.title }
        }
    }

    func load() async {
        loading = true
        defer { loading = false }
        do {
            lines = try await repository.lines()
            error = nil
        } catch {
            error = "Hatlar yüklenemedi."
        }
    }
}
