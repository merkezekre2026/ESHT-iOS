import Foundation

final class CSVDataService {
    enum Dataset: CaseIterable {
        case lines
        case routes
        case stops
        case timetables
    }

    private let config: AppConstants
    private let network: NetworkServing
    private let parser = CSVParser()

    init(config: AppConstants, network: NetworkServing = NetworkService()) {
        self.config = config
        self.network = network
    }

    func fetch(dataset: Dataset) async throws -> [[String: String]] {
        guard let url = config.csvURLs[dataset] else { return [] }
        let data = try await network.data(from: url)
        guard let text = String(data: data, encoding: .utf8) else { return [] }
        return parser.parseRows(text)
    }
}
