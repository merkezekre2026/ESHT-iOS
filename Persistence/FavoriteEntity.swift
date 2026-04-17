import Foundation
import SwiftData

@Model
final class FavoriteEntity {
    enum FavoriteType: String, Codable {
        case line
        case stop
    }

    @Attribute(.unique) var key: String
    var id: String
    var typeRaw: String
    var createdAt: Date

    init(id: String, type: FavoriteType, createdAt: Date = .now) {
        self.id = id
        self.typeRaw = type.rawValue
        self.createdAt = createdAt
        self.key = "\(type.rawValue)-\(id)"
    }
}
