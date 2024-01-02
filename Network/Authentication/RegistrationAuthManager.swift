//
//  RegistrationAuthManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 18.12.23.
//

import Alamofire
import UIKit

final class RegistrationAuthManager {
    private enum Endpoints {
        static let makeRegistrationEndpoint: String = GlobalNetworkConstants.host + "/people/new"
    }

    static func makeRegistrationRequest(user: User, completion: @escaping (MakeRegistrationRequestResponseEntity?) -> Void) {
        let parametrs: Parameters = [
            "name": user.name,
            "phoneNumber": user.phoneNum,
            "dateOfBirth": user.birthday,
            "gender": user.sex,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.makeRegistrationEndpoint, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: MakeRegistrationRequestResponseEntity.self) { response in
            completion(response.value)
        }
    }
}
