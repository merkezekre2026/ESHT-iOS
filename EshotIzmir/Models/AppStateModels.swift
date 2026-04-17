import Foundation

struct SyncState: Equatable {
    var isLoading = false
    var lastSyncDate: Date?
    var errorMessage: String?
}

struct HomeQuickSection: Identifiable {
    let id = UUID()
    let title: String
    let icon: String
    let route: Route

    enum Route {
        case lines
        case stops
        case timetables
        case nearby
        case favorites
    }
}
