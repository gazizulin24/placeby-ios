//
//  ProfileTableViewCellType.swift
//  placeby
//
//  Created by Timur Gazizulin on 20.12.23.
//

enum ProfileTableViewCellType {
    case username
    case buttonCell(String, String)
    case multiCell(ProfileTableViewCellTypeMultiCell)
    case multiCellSubcell(String, String, String)
    case smallLabel(String)
}

typealias ProfileTableViewCellTypeMultiCell = [ProfileTableViewCellType]
