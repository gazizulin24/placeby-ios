//
//  UserNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 19.12.23.
//

import Alamofire

class UserNetworkManager {
    private enum Endpoints {
        static let getUserEndpoint: String = GlobalNetworkConstants.host + "/people/"
        static let userIdByPhoneNumEndpoint: String = GlobalNetworkConstants.host + "/people/userId"
    }

    static func makeGetPersonRequest(id: Int, completion: @escaping (GetPersonResponseEntity?) -> Void) {
        let url = Endpoints.getUserEndpoint + String(id)

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetPersonResponseEntity.self) { response in
            completion(response.value)
        }
    }

    static func makeUserIdByPhoneNumRequest(phoneNum: String, completion: @escaping (GetPersonIdResponseEntity?) -> Void) {
        let parametrs: Parameters = [
            "phoneNumber": phoneNum,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.userIdByPhoneNumEndpoint, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: GetPersonIdResponseEntity.self) { response in
            completion(response.value)
        }
    }
}
