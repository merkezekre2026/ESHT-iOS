import Foundation
import SwiftData

@MainActor
final class FavoritesService {
    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }

    func toggle(id: String, type: FavoriteEntity.FavoriteType) throws {
        let descriptor = FetchDescriptor<FavoriteEntity>(predicate: #Predicate { $0.id == id && $0.typeRaw == type.rawValue })
        if let existing = try context.fetch(descriptor).first {
            context.delete(existing)
        } else {
            context.insert(FavoriteEntity(id: id, type: type))
        }
        try context.save()
    }

    func all() throws -> [FavoriteEntity] {
        try context.fetch(FetchDescriptor<FavoriteEntity>())
    }
}
