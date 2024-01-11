//
//  User.swift
//  placeby
//
//  Created by Timur Gazizulin on 18.12.23.
//

import Foundation

struct User {
    let phoneNum: String
    let name: String
    let birthday: String
    let sex: String

    static func calculateAge() -> Int? {
        let dateOfBirth = UserDefaults.standard.string(forKey: "userDateOfBirth") ?? "0000-00-00"
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateOfBirth

        guard let birthDate = dateFormatter.date(from: dateOfBirth) else {
            return nil
        }

        let calendar = Calendar.current
        let currentDate = Date()
        let ageComponents = calendar.dateComponents([.year], from: birthDate, to: currentDate)
        let age = ageComponents.year

        return age
    }
}
