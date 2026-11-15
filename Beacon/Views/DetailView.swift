//
//  DetailView.swift
//  Beacon

import SwiftUI
import SwiftData

struct DetailView: View {

    //Vi lager context for å muliggjøre lagring
    @Environment(\.modelContext) private var modelContext
    @Environment(\.dismiss) private var dismiss

    @State private var rotation: Double = 0
    @State private var isSteaming = false
    @State private var ScaleHotel: CGFloat = 0.5
    @AppStorage("rating") private var rating = 0

    //Info om valgt sted & kategori fra ExploreView
    let poi: PlaceOfInterest
    let selectedCategory: String

    //Lagrer følgende data i context etter valgt sted innenfor kategorivelgeren
    func onSaveButtonTapped() {
        let savedFavorites = FavoritePlace (
            id: UUID(),
            name: poi.name,
            formatted: poi.formatted,
            latitude: poi.latitude,
            longitude: poi.longitude,
            category: selectedCategory,
            phone: poi.phone,
            openingHours: poi.openingHours,
            rating: rating
        )

        modelContext.insert(savedFavorites)
        dismiss()

    }


    var body: some View {
        VStack {
            VStack {
                if selectedCategory == "Restauranter" {
                    Text("🍽")
                        .font(.system(size: 80))
                        .rotationEffect(.degrees(rotation))
                } else if selectedCategory == "Kafeer" {
                    Circle()
                        .frame(width: 7, height: 7)
                        .opacity(isSteaming ? 0.0 : 1.0)
                        .offset(y: isSteaming ? -35 : 40)
                        .offset(x: -13)
                        .animation(
                            .easeOut(duration: 1.2)
                            .repeatForever(autoreverses: false), value: isSteaming
                        )
                    Circle()
                        .frame(width: 10, height: 10)
                        .opacity(isSteaming ? 0.0 : 1.0)
                        .offset(y: isSteaming ? -40 : 40)
                        .offset(x: -3)
                        .animation(
                            .easeOut(duration: 2)
                            .repeatForever(autoreverses: false), value: isSteaming
                        )
                    Circle()
                        .frame(width: 8, height: 8)
                        .opacity(isSteaming ? 0.0 : 1.0)
                        .offset(y: isSteaming ? -35 : 40)
                        .offset(x: 12)
                        .animation(
                            .easeOut(duration: 1.5)
                            .repeatForever(autoreverses: false), value: isSteaming
                        )
                    Text("☕")
                        .font(.system(size: 80))
                } else if selectedCategory == "Hoteller" {
                    Text("🏨")
                        .font(.system(size: 80))
                        .scaleEffect(ScaleHotel)
                } else {
                    Image(systemName: "x.circle")
                        .font(.system(size: 50))
                }
            }
            .padding(.bottom, 5)

            Text(poi.name)
                .font(.title)
                .bold()
                .padding(30)

            Text(poi.formatted ?? "Ingen addresse")
                .font(.title3)
                .foregroundStyle(.secondary)
                .bold()
                .padding(.bottom, 5)

            Text(poi.phone ?? "Ingen telefonnummer tilgjengelig")
                .font(.title3)
                .foregroundStyle(.secondary)
                .bold()
                .padding(.bottom, 5)

            Text(poi.openingHours ?? "Ingen tidspunkter å vise")
                .font(.title3)
                .foregroundStyle(.secondary)
                .bold()

            Text("Latitude: \(poi.latitude) Longitude: \(poi.longitude)")
                .font(.subheadline)
                .foregroundStyle(.secondary)
                .padding(.top, 20)

            Text("Vurder stedet")
                .font(.callout)
                .foregroundStyle(.secondary)
                .padding(.top, 20)

            Picker("Rating", selection: $rating) {
                ForEach(1...5, id: \.self) { rating in
                    Text("\(rating)")

                }
            }
            .frame(maxWidth: 200)
            .pickerStyle(.segmented)


            Button {
                onSaveButtonTapped()
            } label: {
                HStack {
                    Text("Lagre")
                    Image(systemName: "square.and.arrow.down")
                }
                .font(.headline)
                .frame(width: 100, height: 20)
                .padding(15)
                .background(Color("Beacon Orange"))
                .foregroundStyle(.white)
                .cornerRadius(15)

            }
            .padding(.top, 20)
        }
        .padding()
        .onAppear {
            if selectedCategory == "Restauranter" {
                withAnimation(.easeInOut(duration: 1)) {
                    rotation += 360
                }
            }
            if selectedCategory == "Kafeer" {
                isSteaming = true
            } else {
                if selectedCategory == "Hoteller" {
                    withAnimation(.spring(response: 0.6, dampingFraction: 0.2)) {
                        ScaleHotel = 1.0
                    }
                }
            }
        }
    }
}
