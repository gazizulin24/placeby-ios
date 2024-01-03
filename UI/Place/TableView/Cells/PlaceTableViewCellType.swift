//
//  PlaceTableViewCellType.swift
//  placeby
//
//  Created by Timur Gazizulin on 1.01.24.
//

import Foundation


enum PlaceTableViewCellType {
    case images([PlacePhotoResponseEntity])
    case description(GetAllPlacesRequestResponseSingleEntity)
    case categories(GetAllPlacesRequestResponseSingleEntity)
    case map(GetAllPlacesRequestResponseSingleEntity)
    case similar(GetAllPlacesRequestResponseSingleEntity)
    case report(String)
    case smallLabel(String)
}
