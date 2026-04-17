# Eshot İzmir (SwiftUI)

Modern, premium tasarımlı ESHOT toplu ulaşım uygulaması.

## Proje Yapısı

- `App`
- `Models`
- `ViewModels`
- `Views`
- `Components`
- `Services`
- `Repositories`
- `Parsers`
- `Utilities`
- `Persistence`

## Gerçek Veri Kaynakları

- GTFS: `https://www.eshot.gov.tr/gtfs/bus-eshot-gtfs.zip`
- CSV endpointleri: `Utilities/AppConstants.swift` içinde
- Canlı API endpointleri: `Utilities/AppConstants.swift` içinde placeholder olarak tanımlı

## Önemli Not

GTFS zip açma için `ZIPFoundation` kullanımı desteklenir.
Xcode'da **Add Package Dependency** ile ekleyin:
- `https://github.com/weichsel/ZIPFoundation`

`ZIPFoundation` eklendiğinde `GTFSZipExtractor` gerçek zip içeriğini açar.
Eklenmediğinde repository, cache fallback stratejisine döner.

## Mimari

- MVVM + Repository
- Async/Await + URLSession
- GTFS + CSV + API birleşik domain modelleri
- Cache + hata durumunda fallback
- SwiftData ile favori altyapısı
