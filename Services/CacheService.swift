import Foundation

final class CacheService {
    private let decoder = JSONDecoder()
    private let encoder = JSONEncoder()

    private var cacheDirectory: URL {
        FileManager.default.urls(for: .cachesDirectory, in: .userDomainMask).first!
    }

    func write<T: Encodable>(_ value: T, key: String) throws {
        let url = cacheDirectory.appendingPathComponent(key).appendingPathExtension("json")
        let data = try encoder.encode(value)
        try data.write(to: url, options: .atomic)
    }

    func read<T: Decodable>(_ type: T.Type, key: String) throws -> T {
        let url = cacheDirectory.appendingPathComponent(key).appendingPathExtension("json")
        let data = try Data(contentsOf: url)
        return try decoder.decode(type, from: data)
    }
}
