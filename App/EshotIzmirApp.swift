import SwiftUI
import SwiftData

@main
struct EshotIzmirApp: App {
    private let container: ModelContainer = {
        let schema = Schema([
            FavoriteEntity.self,
            SyncMetadataEntity.self
        ])
        let config = ModelConfiguration("EshotIzmirStore")
        return try! ModelContainer(for: schema, configurations: [config])
    }()

    @StateObject private var appContext = AppContext.makeDefault()

    var body: some Scene {
        WindowGroup {
            RootTabView()
                .environmentObject(appContext)
        }
        .modelContainer(container)
    }
}
