import SwiftUI

struct StopCardView: View {
    let stop: Stop

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(stop.name)
                .font(.headline)
            HStack {
                Label("Kod: \(stop.code)", systemImage: "number")
                Spacer()
                Label("\(stop.lineIDs.count) hat", systemImage: "bus")
            }
            .font(.footnote)
            .foregroundStyle(.secondary)
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
    }
}
