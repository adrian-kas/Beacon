//
//  SecondaryView.swift
//  Beacon

import SwiftData
import SwiftUI

//Viser en liste over brukerens lagrede favoritiserte steder
//Data hentes rett fra SwiftData og kan slettes fra listen
struct MyPlacesView: View {
    
    
    @Query(sort: \FavoritePlace.name) private var favorites: [FavoritePlace]
    @Environment(\.modelContext) private var modelContext

    //Sletter valgte data fra favorittlisten
    func onDeleteFavorites(at offsets: IndexSet) {
        for index in offsets {
            let place = favorites[index]
            modelContext.delete(place)
            
            try! modelContext.save()
        }
    }
    
    var body: some View {
        VStack {
            Text("Lagrede Steder")
                .font(.headline)
                .padding()
            
            if favorites.isEmpty {
                Text("Ingen steder lagret.")
                    .foregroundStyle(.gray)
                    .padding()
            } else {
                List {
                    ForEach(favorites) { place in
                        VStack(alignment: .leading) {
                            HStack {
                                Image(systemName: "pencil.line")
                                Text(place.name)
                                    .font(.headline)
                                    .padding(.bottom, 2)
                            }
                            
                            HStack {
                                Image(systemName: "envelope.front")
                                Text(place.formatted ?? "Ingen adresse å vise")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 2)
                            }
                            
                            HStack {
                                Image(systemName: "phone")
                                Text("\(place.phone ?? "Ingen telefonnummer å vise")")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 2)
                            }
                            
                            HStack {
                                Image(systemName: "clock")
                                Text("\(place.openingHours ?? "Ingen tidspunkter å vise")")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 2)
                            }
                            
                            HStack {
                                Image(systemName: "location")
                                Text("Lat: \(place.latitude), Lon: \(place.longitude)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .padding(.bottom, 8)
                            }
                            
                            HStack {
                                Image(systemName: "list.bullet")
                                Text("Kategori: \(place.category)")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                            }
                            
                            HStack {
                                Image(systemName: "star")
                                if let rating = place.rating {
                                    Text("Rating: \(rating) / 5")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                } else {
                                    Text("Ingen rating.")
                                        .font(.subheadline)
                                        .foregroundStyle(.secondary)
                                }
                            }
                            
                            HStack {
                                Image(systemName: "delete.left")
                                Text("Sveip for å slette")
                                    .font(.subheadline)
                                    .foregroundStyle(.secondary)
                                    .frame(width: 140, height: 25)
                                    .background(Color.red)
                                    .foregroundStyle(.white)
                                    .cornerRadius(5)
                                    .padding(5)
                            }
                        }
                    }
                    .onDelete(perform: onDeleteFavorites)
                }
                .navigationTitle("Mine Favoritter")
            }
        }
    }
}
