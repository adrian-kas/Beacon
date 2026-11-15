//
//  PlacesAPI.swift
//  Beacon

//Henter og dekoder data fra Geoapify API-et
//Inneholder liste med features fra API-responsen
struct Response: Decodable {
    let features: [Feature]
}

//Enkelt objekt fra API i responsen
struct Feature: Decodable {
    let properties: Properties
}

//henter inn detaljert om hver enkelt sted
struct Properties: Decodable {
    let name: String?
    let formatted: String?
    let lon: Double
    let lat: Double
    let openingHours: String?
    let phone: String?
    
    enum CodingKeys: String, CodingKey {
        case name, formatted, lon, lat, phone
        case openingHours = "opening_hours"
    }
}
