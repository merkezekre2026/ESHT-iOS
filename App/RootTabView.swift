import SwiftUI

struct RootTabView: View {
    var body: some View {
        TabView {
            NavigationStack { HomeView() }
                .tabItem { Label("Ana Sayfa", systemImage: "house.fill") }

            NavigationStack { LinesView() }
                .tabItem { Label("Hatlar", systemImage: "point.topleft.down.curvedto.point.bottomright.up") }

            NavigationStack { StopsView() }
                .tabItem { Label("Duraklar", systemImage: "mappin.and.ellipse") }

            NavigationStack { TimetablesView() }
                .tabItem { Label("Saatler", systemImage: "clock.fill") }

            NavigationStack { FavoritesView() }
                .tabItem { Label("Favoriler", systemImage: "star.fill") }
        }
        .tint(Color.teal)
    }
}

#Preview {
    RootTabView()
        .environmentObject(AppContext.makeDefault())
}
