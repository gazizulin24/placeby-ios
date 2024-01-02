//
//  PlaceType.swift
//  placeby
//
//  Created by Timur Gazizulin on 27.12.23.
//

import Foundation

 struct PlaceType {
    let title: String
    let dbTitle: String

    static let basicTypes = [PlaceType(title: "Все", dbTitle: "all"),
                             PlaceType(title: "Развлечения", dbTitle: "entertainment"),
                             PlaceType(title: "Новые", dbTitle: "new"),
                             PlaceType(title: "Рыбалка", dbTitle: "fishing"),
                             PlaceType(title: "Семьей", dbTitle: "family"),
                             PlaceType(title: "Парой", dbTitle: "pair"),
                             PlaceType(title: "Знаковые места", dbTitle: "attractions"),
                             PlaceType(title: "Активный отдых", dbTitle: "activeVacation"),
                             PlaceType(title: "Большой компанией", dbTitle: "bigCompany"),
                             PlaceType(title: "Разные", dbTitle: "other")]

    static func savePlaceTypeToUserDefaults(placeType: PlaceType) {
        UserDefaults.standard.setValue(placeType.title, forKey: "allPlacesFilterTitle")
        UserDefaults.standard.setValue(placeType.dbTitle, forKey: "allPlacesFilterDBTitle")
    }

    static func getPlaceTypeFromUserDefaults() -> PlaceType? {
        guard let placeTitle = UserDefaults.standard.string(forKey: "allPlacesFilterTitle") else { return nil }
        guard let placeDBTitle = UserDefaults.standard.string(forKey: "allPlacesFilterDBTitle") else { return nil }

        return PlaceType(title: placeTitle, dbTitle: placeDBTitle)
    }
}
