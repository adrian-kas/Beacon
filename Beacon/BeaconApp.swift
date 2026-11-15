//
//  BeaconApp.swift
//  Beacon

import SwiftUI
import SwiftData

@main
struct BeaconApp: App {
    var body: some Scene {
        WindowGroup {
            MainTabView()
        }
        .modelContainer(for: FavoritePlace.self)
    }
}

struct MainTabView: View {
    var body: some View {
        TabView{
            ExploreView()
                .tabItem {
                    Label("Utforsk", systemImage: "map")
                }
            MyPlacesView()
                .tabItem {
                    Label("Mine Steder", systemImage: "text.below.folder")
                }
        }
    }
}

#Preview {
    MainTabView()
}
