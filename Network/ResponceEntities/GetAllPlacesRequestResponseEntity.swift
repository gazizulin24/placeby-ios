//
//  GetAllPlacesRequestResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 27.12.23.
//

import Foundation

// MARK: - WelcomeElement
struct GetAllPlacesRequestResponseSingleEntity: Codable {
    let id: Int
    let nameOfPlace, description: String
    let photos: [PlacePhotoResponseEntity]
    let longitude, latitude: Double
}

// MARK: - Photo
struct PlacePhotoResponseEntity: Codable {
    let id: Int
    let photoURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case photoURL = "photoUrl"
    }
}

typealias GetAllPlacesRequestResponseEntity = [GetAllPlacesRequestResponseSingleEntity]
