//
//  GetRecentlyPlacesResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import Foundation

// MARK: - GetRecentlyPlacesResponseEntity
struct GetRecentlyPlacesResponseEntity: Codable {
    let recentlyPlaces: [RecentlyPlace]
}

// MARK: - RecentlyPlace
struct RecentlyPlace: Codable {
    let id: Int
    let nameOfPlace, description: String
    let photos: [PlacePhotoResponseEntity]
    let longitude, latitude: Double
}

