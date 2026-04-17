import Foundation

@MainActor
final class TimetablesViewModel: ObservableObject {
    @Published var entries: [TimetableEntry] = []
    @Published var selectedDay: TimetableEntry.DayType = .weekday
    @Published var error: String?

    private let repository: TransitRepository

    init(repository: TransitRepository) {
        self.repository = repository
    }

    var filtered: [TimetableEntry] {
        entries.filter { $0.dayType == selectedDay }
    }

    func load(lineID: String? = nil) async {
        do {
            entries = try await repository.timetables(lineID: lineID)
        } catch {
            error = "Saat bilgisi alınamadı."
        }
    }
}
