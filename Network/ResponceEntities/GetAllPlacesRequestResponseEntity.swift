//
//  GetAllPlacesRequestResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 27.12.23.
//

import Foundation

// MARK: - GetAllPlacesRequestResponseSingleEntity

struct GetAllPlacesRequestResponseSingleEntity: Codable {
    let id: Int
    let nameOfPlace, description: String
    let photos: [PlacePhotoResponseEntity]
    let longitude, latitude: Double
}



typealias GetAllPlacesRequestResponseEntity = [GetAllPlacesRequestResponseSingleEntity]
