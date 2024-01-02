//
//  PlacePhotoResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import Foundation

// MARK: - PlacePhotoResponseEntity

 struct PlacePhotoResponseEntity: Codable {
    let id: Int
    let photoURL: String

    enum CodingKeys: String, CodingKey {
        case id
        case photoURL = "photoUrl"
    }
}
