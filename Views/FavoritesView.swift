import SwiftUI

struct FavoritesView: View {
    var body: some View {
        VStack(spacing: 12) {
            Image(systemName: "star.circle.fill")
                .font(.system(size: 44))
                .foregroundStyle(Color.eshotPrimary)
            Text("Favoriler")
                .font(.title2.bold())
            Text("Favori hat ve duraklar burada çevrimdışı saklanır.")
                .multilineTextAlignment(.center)
                .foregroundStyle(.secondary)
        }
        .padding()
        .navigationTitle("Favoriler")
    }
}
