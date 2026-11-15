//
//  PlaceOfInterest.swift
//  Beacon

import SwiftUI
import MapKit

//Vi henter inn sted fra API, dette brukes til å vise info på kart, men også listevisningen vi har
struct PlaceOfInterest: Hashable {
    let name: String
    let formatted: String?
    let phone: String?
    let openingHours: String?
    let latitude: CLLocationDegrees
    let longitude: CLLocationDegrees
    let rating: Int?
    
    //Returnerer koordinater som brukes av MapKit
    var coordinate: CLLocationCoordinate2D {
        return CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
    }
}
