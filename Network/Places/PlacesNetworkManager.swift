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
    }

    static func getAllPlacesRequest(completion: @escaping (GetAllPlacesRequestResponseEntity?) -> Void) {
        AF.request(Endpoints.getAllPlacesEndpoint, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetAllPlacesRequestResponseEntity.self) { response in
            completion(response.value)
        }
    }
}
