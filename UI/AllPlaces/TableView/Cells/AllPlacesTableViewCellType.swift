//
//  AllPlacesTableViewCellType.swift
//  placeby
//
//  Created by Timur Gazizulin on 14.12.23.
//

import Foundation

enum AllPlacesTableViewCellType {
    case title(String)
    case smallTitle(String)
    case place(GetAllPlacesRequestResponseSingleEntity)
    case placeTypes
    case recomendations(RecomedationsData)
    case loading
}
