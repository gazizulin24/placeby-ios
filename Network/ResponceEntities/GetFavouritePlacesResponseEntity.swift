//
//  GetFavouritePlacesResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import Foundation

// MARK: - GetFavouritePlacesResponseEntity

 struct GetFavouritePlacesResponseEntity: Codable {
    let favPlaces: [GetAllPlacesRequestResponseSingleEntity]
}
