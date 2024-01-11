//
//  GetPersonResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 19.12.23.
//

import Foundation

struct GetPersonResponseEntity: Decodable {
    let name: String
    let phoneNumber: String
    let dateOfBirth: String
    let gender: String
}
