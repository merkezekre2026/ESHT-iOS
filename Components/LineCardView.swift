import SwiftUI

struct LineCardView: View {
    let line: Line

    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            HStack {
                Text(line.number)
                    .font(.title3.bold())
                    .padding(.horizontal, 12)
                    .padding(.vertical, 6)
                    .background(Color.eshotPrimary.opacity(0.15))
                    .clipShape(Capsule())

                Spacer()

                if let colorHex = line.colorHex {
                    Text("#\(colorHex)")
                        .font(.caption)
                        .foregroundStyle(.secondary)
                }
            }

            Text(line.title)
                .font(.headline)

            if let outbound = line.outboundName, let inbound = line.inboundName {
                Text("\(outbound) • \(inbound)")
                    .font(.subheadline)
                    .foregroundStyle(.secondary)
            }
        }
        .padding()
        .background(Color.cardBackground)
        .clipShape(RoundedRectangle(cornerRadius: 18, style: .continuous))
    }
}
