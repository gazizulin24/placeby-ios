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
    let types: [PlaceTypeResponseEntity]
    let todayTimetable: TodayTimetable?
    let rating: Double
    let isOpen: Bool?

    enum CodingKeys: String, CodingKey {
        case id, nameOfPlace, photos, longitude, latitude, types, todayTimetable, rating, description, isOpen
    }
}

typealias GetAllPlacesRequestResponseEntity = [GetAllPlacesRequestResponseSingleEntity]

struct TodayTimetable: Codable {
    let dayOfWeek, startTime, endTime: String
}
