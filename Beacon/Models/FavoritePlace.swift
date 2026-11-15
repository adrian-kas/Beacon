//
//  FavoritePlace.swift
//  Beacon

import SwiftUI
import SwiftData


//Lagrer og henter ut i fra lagrede data ved bruk av swiftdata
@Model
class FavoritePlace {

    var id: UUID
    var name: String
    var formatted: String?
    var latitude: Double
    var longitude: Double
    var category: String
    var phone: String?
    var openingHours: String?
    var rating: Int?

    init(id: UUID, name: String, formatted: String?, latitude: Double, longitude: Double, category: String, phone: String?, openingHours: String?, rating: Int?) {
        self.id = id
        self.name = name
        self.formatted = formatted
        self.latitude = latitude
        self.longitude = longitude
        self.category = category
        self.phone = phone
        self.openingHours = openingHours
        self.rating = rating
    }


}
