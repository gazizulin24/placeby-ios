//
//  ConfirmPhoneNumberRequestResponseEntity.swift
//  placeby
//
//  Created by Timur Gazizulin on 18.12.23.
//

import Foundation

struct ConfirmPhoneNumberRequestResponseEntity: Decodable {
    let isRegistred: Bool?
    let isCodeValid: Bool
}
