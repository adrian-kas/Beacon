//
//  ContentView.swift
//  Beacon

import SwiftUI
import MapKit
import SwiftData
import Combine

//Dette er hovedvisningen i appen
//Vi kan søke, filtrere, justere radius, lagre favoritter via sheet, Listview
struct ExploreView: View {

    //Statiske hardkodet data hvis ikke lokasjon fungerer
    @AppStorage("lastSavedLat") private var lastSavedLat: Double = 59.9111
    @AppStorage("lastSavedLon") private var lastSavedLon: Double = 10.7503

    //Startposisjon til kartet
    @State private var position: MapCameraPosition = .region(

        MKCoordinateRegion(center:
                            CLLocationCoordinate2D(latitude: 59.9111, longitude: 10.7503),
                           span: MKCoordinateSpan.init(latitudeDelta: 0.04, longitudeDelta: 0.04)))

    @State private var isShowingSheet = false
    @State private var selectedPOI: PlaceOfInterest?
    @State private var isLoading = false
    @State private var places: [PlaceOfInterest] = []
    @AppStorage("selectedCategory") private var selectedCategory = "Restauranter"
    @State private var errorMessage: String?
    @State private var showingList = false
    @State private var searchText = ""
    @AppStorage("defaultRadiusKm") private var defaultRadiusKm: Double = 5.0
    @StateObject private var locationViewModel = LocationViewModel()

    let categories = ["Restauranter", "Kafeer", "Hoteller"]


    var filteredPlaces: [PlaceOfInterest] {
        if searchText.isEmpty {
            return places
        }
        return places
            .filter { place in

                return place.name.localizedCaseInsensitiveContains(searchText)
            }
    }


    //Henter steder fra API baserrt på valgt kategori og radius
    func getPlaces() async {
        isLoading = true
        errorMessage = nil

        guard let apiKey = Bundle.main.object(forInfoDictionaryKey: "GEOAPIFY_API_KEY") as? String,
              !apiKey.isEmpty else {
            errorMessage = "Geoapify API key is not configured."
            isLoading = false
            return
        }

        var chosenCategory = ""

        if selectedCategory == "Restauranter" {
            chosenCategory = "catering.restaurant"
        } else if selectedCategory == "Kafeer" {
            chosenCategory = "catering.cafe"
        } else if selectedCategory == "Hoteller" {
            chosenCategory = "accommodation.hotel"
        }

        do {

            let radius = Int(defaultRadiusKm * 1000)

            var center = CLLocationCoordinate2D(latitude: lastSavedLat, longitude: lastSavedLon)

            if let
                region = (position.region) {
                center = region.center
            }
            else if let
                        userLocation = locationViewModel.location {
                center = userLocation.coordinate
            }

            var urlComponents = URLComponents(string: "https://api.geoapify.com/v2/places")!
            urlComponents.queryItems = [
                URLQueryItem(name: "categories", value: chosenCategory),
                URLQueryItem(name: "filter", value: "circle:\(center.longitude),\(center.latitude),\(radius)"),
                URLQueryItem(name: "limit", value: "10"),
                URLQueryItem(name: "apiKey", value: apiKey)
            ]
            guard let url = urlComponents.url else {
                throw URLError(.badURL)
            }
            let (data, response) = try await URLSession.shared.data(from: url)

            let fetchedPlaces = try JSONDecoder().decode(Response.self, from: data)

            places = fetchedPlaces.features.map { feature in
                PlaceOfInterest(
                    name: feature.properties.name ?? "Ingen navn",
                    formatted: feature.properties.formatted ?? "Ingen addresse",
                    phone: feature.properties.phone ?? "Ingen TLF-nummer tilgjengelig",
                    openingHours: feature.properties.openingHours ?? "Ingen tidspunkter tilgjengelig",
                    latitude: feature.properties.lat,
                    longitude: feature.properties.lon,
                    rating: nil
                )
            }
            isLoading = false

        } catch let error {
            errorMessage = "Noe feil skjedde: //\(error.localizedDescription)"
            isLoading = false
        }
    }

    var body: some View {
        ZStack {
            if showingList {
                VStack {

                    HStack {
                        TextField("Søk steder...", text: $searchText)
                            .textFieldStyle(.roundedBorder)
                            .background(Color("Beacon Orange"))
                            .clipShape(Capsule())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.horizontal, 30)
                            .padding(.top, 6)
                            .opacity(0.7)

                        Button{
                            Task {
                                await getPlaces()
                            }
                        } label: {
                            Text("Hent")
                        }
                        .padding(.vertical, 6)
                        .padding(.horizontal, 10)
                        .background(Color("Beacon Orange"))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .shadow(color: .gray, radius: 2, x: 2, y: 2)
                        .padding()


                    }

                    HStack {
                        Spacer()
                        Button {
                            showingList = false
                        } label: {
                            HStack {
                                Image(systemName: "map")
                                Text("Kart")
                            }
                            .padding(.vertical, 3)
                            .padding(.horizontal, 20)
                            .background(Color("Beacon Orange"))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.trailing)

                        }
                        .padding(.top)

                    }
                    ListView(places: filteredPlaces)
                    Spacer()
                }

            } else {

                ZStack {

                    Map(position: $position) {
                        ForEach(filteredPlaces, id: \.self) { location in

                            Annotation(location.name, coordinate: location.coordinate) {
                                Button {
                                    print(location.name)
                                    selectedPOI = location
                                    isShowingSheet = true
                                } label: {
                                    if selectedPOI == location {
                                        PinView()
                                    } else {
                                        ZStack {
                                            Circle()
                                            Image("pinsmall")
                                                .resizable()
                                                .frame(width: 50, height: 50)
                                                .shadow(color: .gray, radius: 5)
                                        }
                                    }
                                }.sheet(isPresented: $isShowingSheet) {

                                    if let selectedPOI = selectedPOI {
                                        DetailView(poi: selectedPOI, selectedCategory: selectedCategory)
                                    } else {
                                        Text("Ingen informasjon tilgjengelig...")
                                    }
                                }
                            }
                        }
                    }

                    VStack {

                        HStack {
                            TextField("Søk steder...", text: $searchText)
                                .textFieldStyle(.roundedBorder)
                                .background(Color("Beacon Orange"))
                                .clipShape(Capsule())
                                .shadow(color: .gray, radius: 2, x: 2, y: 2)
                                .padding(.horizontal, 50)
                                .padding(.top, 6)
                                .opacity(0.7)
                        }
                        .padding(5)

                        HStack {
                            Image(systemName: "slider.horizontal.below.rectangle")
                            Text("Radius: \(Int(defaultRadiusKm)) KM")

                        }
                        .padding(8)
                        .font(.subheadline)
                        .background(Color("Beacon Orange"))
                        .foregroundStyle(.white)
                        .clipShape(Capsule())
                        .opacity(0.8)

                        HStack {

                            Slider(value: $defaultRadiusKm, in: 1...10, step: 1)
                                .onChange(of: defaultRadiusKm) {
                                    Task {
                                        await getPlaces()
                                    }
                                }
                        }
                        .padding(.horizontal, 70)



                        HStack {

                            Picker("Velg Kategori", selection: $selectedCategory) {
                                ForEach(categories, id: \.self) {categories in
                                    Text(categories)
                                }
                            }.onChange(of: selectedCategory) {
                                Task {
                                    await getPlaces()
                                }
                            }
                            .background(Color("Beacon Orange"))
                            .pickerStyle(.segmented)
                            .clipShape(Capsule())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding()

                            Button{
                                Task {
                                    await getPlaces()
                                }
                            } label: {
                                Text("Hent")
                            }
                            .padding(.vertical, 6)
                            .padding(.horizontal, 10)
                            .background(Color("Beacon Orange"))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            Spacer()

                        }

                        HStack {
                            Spacer()
                            Button{
                                showingList = true
                            } label: {
                                HStack {
                                    Image(systemName: "list.bullet")
                                    Text("Liste")
                                }
                            }
                            .padding(.vertical, 3)
                            .padding(.horizontal, 20)
                            .background(Color("Beacon Orange"))
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            .shadow(color: .gray, radius: 2, x: 2, y: 2)
                            .padding(.trailing)
                        }

                        if isLoading {
                            ProgressView("Vennligst vent...")
                                .padding(20)
                                .background(Color("Beacon Orange"))
                                .opacity(0.8)
                                .cornerRadius(15)
                        } else if let errorMessage = errorMessage {
                            Text(errorMessage)
                        }
                        Spacer()
                    }

                    VStack {
                        Spacer()

                        HStack {
                            Button {
                                searchText = ""
                                defaultRadiusKm = 5.0
                                selectedCategory = "Restauranter"

                                Task {
                                    await getPlaces()
                                }
                            } label: {
                                Image(systemName: "clear")
                                Text("Nullstill Søk")

                            }
                            .padding(8)
                            .font(.subheadline)
                            .background(Color.secondary)
                            .foregroundStyle(.white)
                            .clipShape(Capsule())
                            Spacer()

                            Button {
                                position = .region(MKCoordinateRegion.init(center:
                                        .init(latitude: 59.9111, longitude: 10.7503), span:
                                        .init(latitudeDelta: 0.1, longitudeDelta: 0.1)))
                            } label: {
                                Image("location")
                                    .resizable()
                                    .frame(width: 125, height: 125)
                                    .shadow(color: .gray, radius: 5)
                            }
                        }
                        .padding(.horizontal, 10)
                        .padding(.bottom, 10)

                    }

                }
            }
        }
        .onAppear {
            locationViewModel.requestLocation()
        }
    }
}
