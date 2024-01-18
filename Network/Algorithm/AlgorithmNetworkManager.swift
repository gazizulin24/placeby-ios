//
//  AlgorithmNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 11.01.24.
//

import Alamofire

enum AlgorithmNetworkManager {
    private enum Endpoints {
        static let startAlgorithm: String = GlobalNetworkConstants.host + "/algorithm/start"
    }

    static func findPlace(completion: @escaping (GetAllPlacesRequestResponseSingleEntity?) -> Void) {
        guard let userAge = User.calculateAge() else {print("error getting user age"); return}
        guard let userGender = UserDefaults.standard.string(forKey: "userGender") else {print("error getting user gender"); return}
        let countOfPeople = UserDefaults.standard.integer(forKey: "countOfPeople")
        let isActiveRelax = UserDefaults.standard.bool(forKey: "isActiveRelax")
        let isNearbyOrNo = UserDefaults.standard.bool(forKey: "isNearbyOrNo")
        let latPerson = UserDefaults.standard.double(forKey: "userLatitude")
        let lonPerson = UserDefaults.standard.double(forKey: "userLongitude")
        let isFamily = UserDefaults.standard.double(forKey: "isFamily")
        let nearbyRadius = isNearbyOrNo ? UserDefaults.standard.integer(forKey: "placesNearbyRange") : 1000
        let isEntertainment = UserDefaults.standard.bool(forKey: "isEntertainment")
        
        let parametrs: Parameters = [
            "countOfPeople": countOfPeople,
            "nearbyOrNo": isNearbyOrNo,
            "age": userAge,
            "gender": userGender,
            "activeRelax": isActiveRelax,
            "latPerson": latPerson,
            "lonPerson": lonPerson,
            "nearby": nearbyRadius,
            "family": isFamily,
            "entertainment": isEntertainment
            
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.startAlgorithm, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: GetAllPlacesRequestResponseSingleEntity.self) { response in
            
            completion(response.value)
        }
    }
}
