//
//  PlacesNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 27.12.23.
//

import Alamofire

enum PlacesNetworkManager {
    private enum Endpoints {
        static let getAllPlacesEndpoint: String = GlobalNetworkConstants.host + "/places"
        static let getAllPlacesByTypeEndpoint: String = GlobalNetworkConstants.host + "/places/type/"
    }

    static func getAllPlacesRequest(completion: @escaping (GetAllPlacesRequestResponseEntity?) -> Void) {
        AF.request(Endpoints.getAllPlacesEndpoint, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetAllPlacesRequestResponseEntity.self) { response in
            completion(response.value)
        }
    }

    static func getAllPlacesByTypeRequest(_ type: String, completion: @escaping (GetAllPlacesRequestResponseEntity?) -> Void) {
        let url = Endpoints.getAllPlacesByTypeEndpoint + type
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetAllPlacesRequestResponseEntity.self) { response in
            completion(response.value)
        }
    }
}
