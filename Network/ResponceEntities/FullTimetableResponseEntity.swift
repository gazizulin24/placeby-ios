//
//  FullTimetableResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 9.01.24.
//

import Foundation


// MARK: - Welcome
struct FullTimetableResponseEntity: Codable {
    let timetable: [Timetable]
    let nameOfPlace: String
    let isOpen: Bool?

    enum CodingKeys: String, CodingKey {
        case timetable, nameOfPlace, isOpen
    }
    
}

// MARK: - Timetable
struct Timetable: Codable {
    let dayOfWeek, startTime, endTime: String
}
