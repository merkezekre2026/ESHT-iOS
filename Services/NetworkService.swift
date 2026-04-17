import Foundation

protocol NetworkServing {
    func data(from url: URL) async throws -> Data
}

struct NetworkService: NetworkServing {
    func data(from url: URL) async throws -> Data {
        let (data, response) = try await URLSession.shared.data(from: url)
        guard let http = response as? HTTPURLResponse, 200..<300 ~= http.statusCode else {
            throw URLError(.badServerResponse)
        }
        return data
    }
}
