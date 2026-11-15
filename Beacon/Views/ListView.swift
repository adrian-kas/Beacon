//
//  ListView.swift
//  Beacon

import SwiftUI

//Viser liste over alle steder hentet fra API i listeformat
//Viser stedsnavn, adresse, tlfnummer, åpningstider, lokasjonsdata og rating
struct ListView: View {
    let places: [PlaceOfInterest]
    
    
    var body: some View {
        VStack {
            Text("Steder")
                .font(.headline)
                .padding()
            
            if places.isEmpty {
                Text("Ingen steder funnet.")
                    .foregroundStyle(.gray)
                    .padding()
            } else {
                List(places, id: \.self) { place in
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
                        
                    }
                    .padding(.vertical, 5)
                }
            }
        }
    }
    
}
