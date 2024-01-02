//
//  PhoneNumberAuthManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 15.12.23.
//

import Alamofire

final class PhoneNumberAuthManager {
    private enum Endpoints {
        static let sendPhoneNumberEndpoint: String = GlobalNetworkConstants.host + "/authenticate/login"
        static let confirmPhoneNumberEndpoint: String = GlobalNetworkConstants.host + "/authenticate/login/confirmation"
    }

    static func makeSendPhoneNumberRequest(phoneNum: String, completion: @escaping (SendPhoneNumberResponseEntity?) -> Void) {
        let parametrs: Parameters = [
            "phoneNumber": phoneNum,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.sendPhoneNumberEndpoint, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: SendPhoneNumberResponseEntity.self) { response in
            completion(response.value)
        }
    }

    static func makeConfirmPhoneNumberRequest(phoneNum: String, code: String, completion: @escaping (ConfirmPhoneNumberRequestResponseEntity?) -> Void) {
        let parametrs: Parameters = [
            "phoneNumber": phoneNum,
            "verificationCode": code,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.confirmPhoneNumberEndpoint, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: ConfirmPhoneNumberRequestResponseEntity.self) { response in
            completion(response.value)
        }
    }
}

private extension PhoneNumberAuthManager {
    static func handleSendPhoneNumberRequestResponse(_: SendPhoneNumberResponseEntity) {}
}
