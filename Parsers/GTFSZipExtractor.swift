import Foundation
#if canImport(ZIPFoundation)
import ZIPFoundation
#endif

struct GTFSZipExtractor {
    enum ZipError: Error {
        case extractionFailed
    }

    func extractCSVFiles(zipData: Data) throws -> [String: String] {
#if canImport(ZIPFoundation)
        let tempDir = FileManager.default.temporaryDirectory.appendingPathComponent(UUID().uuidString)
        try FileManager.default.createDirectory(at: tempDir, withIntermediateDirectories: true)
        defer { try? FileManager.default.removeItem(at: tempDir) }

        let zipURL = tempDir.appendingPathComponent("gtfs.zip")
        try zipData.write(to: zipURL)

        guard let archive = Archive(url: zipURL, accessMode: .read) else { throw ZipError.extractionFailed }

        var files: [String: String] = [:]
        for entry in archive where entry.path.hasSuffix(".txt") {
            var data = Data()
            _ = try archive.extract(entry) { chunk in
                data.append(chunk)
            }
            files[entry.path] = String(decoding: data, as: UTF8.self)
            let filename = URL(fileURLWithPath: entry.path).lastPathComponent
            files[filename] = String(decoding: data, as: UTF8.self)
        }

        return files
#else
        throw ZipError.extractionFailed
#endif
    }
}
