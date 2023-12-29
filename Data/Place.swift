//
//  Place.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import Foundation

struct Place: Equatable {
    static func == (lhs: Place, rhs: Place) -> Bool {
        return lhs.name == rhs.name &&
            lhs.description == rhs.description &&
            lhs.images == rhs.images &&
            lhs.coordinates.latitude == rhs.coordinates.latitude &&
            lhs.coordinates.longitude == rhs.coordinates.longitude
    }

    let placeId: Int
    let name: String
    let description: String
    let distantion: String
    let images: [String]
    let coordinates: PlaceCoordinates

    static let basicPlaces: [Place] = {
        var places = [Place]()

        // places.append(Place(placeId: 1,name: "Минский Радиотехнический Колледж", description: "Лучший колледж страны", distantion: "3,5км", images: ["mrk", "mrk2"], coordinates: PlaceCoordinates(latitude: 53.919234, longitude: 27.592757)))

        // places.append(Place(placeId: 2,name: "Парк Горького", description: "Парк культуры и отдыха в центре Минска недалеко от Площади Победы.", distantion: "1км", images: ["park", "park2", "park3"], coordinates: PlaceCoordinates(latitude: 53.903133, longitude: 27.573285)))

        // places.append(Place(placeId: 3,name: "Dana Mall", description: "Самый большой торговый центр для всей семьи.", distantion: "6.9км", images: ["dana"], coordinates: PlaceCoordinates(latitude: 53.933853, longitude: 27.652223)))

        return places
    }()
}
