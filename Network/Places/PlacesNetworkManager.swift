//
//  PlacesNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 27.12.23.
//

import Alamofire

final class PlacesNetworkManager {
    private enum Endpoints {
        static let getAllPlacesEndpoint: String = GlobalNetworkConstants.host + "/places"
        static let getAllPlacesByTypeEndpoint: String = GlobalNetworkConstants.host + "/places/type/"
        static let getIsPlaceIsFavouriteForUserEndpoint: String = GlobalNetworkConstants.host + "/places/isFav"
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
    
    static func getPlacebyIdRequest(_ id:Int, completion: @escaping (GetAllPlacesRequestResponseSingleEntity?) -> ()){
        let url = Endpoints.getAllPlacesEndpoint + "/" + String(id)
        
        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetAllPlacesRequestResponseSingleEntity.self) { response in
            completion(response.value)
        }
    }
    
    static func isPlaceIsFavouriteForUser(userId:Int, placeId:Int, completion: @escaping (IsPlaceIsFavouriteResponseEntity?) -> ()){
        let parametrs: Parameters = [
            "personId": userId,
            "placeId": placeId
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.getIsPlaceIsFavouriteForUserEndpoint, method: .get, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: IsPlaceIsFavouriteResponseEntity.self) { response in
            print(response)
            completion(response.value)
        }
    }
}
