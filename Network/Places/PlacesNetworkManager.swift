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
        static let getIsPlaceIsFavouriteForUserEndpoint: String = GlobalNetworkConstants.host + "/places/isFav"
        static let getRatingForPlace: String = GlobalNetworkConstants.host + "/places/rating/"
        static let postRatePlace: String = GlobalNetworkConstants.host + "/places/rating"
        static let getFullTimetable: String = GlobalNetworkConstants.host + "/places/timetable/"
        static let getIsPlaceIsAssigned: String = GlobalNetworkConstants.host + "/places/rating/isAssigned"
        static let reratePlace: String = GlobalNetworkConstants.host + "/places/rating/edit"
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

    static func getPlacebyIdRequest(_ id: Int, completion: @escaping (GetAllPlacesRequestResponseSingleEntity?) -> Void) {
        let url = Endpoints.getAllPlacesEndpoint + "/" + String(id)

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetAllPlacesRequestResponseSingleEntity.self) { response in
            completion(response.value)
        }
    }

    static func isPlaceIsFavouriteForUser(userId: Int, placeId: Int, completion: @escaping (IsPlaceIsFavouriteResponseEntity?) -> Void) {
        let parametrs: Parameters = [
            "personId": userId,
            "placeId": placeId,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.getIsPlaceIsFavouriteForUserEndpoint, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: IsPlaceIsFavouriteResponseEntity.self) { response in
            print(response)
            completion(response.value)
        }
    }

    static func ratePlace(placeId: Int, rating: Int) {
        let parametrs: Parameters = [
            "rating": rating,
            "personId": UserDefaults.standard.integer(forKey: "userId"),
            "placeId": placeId
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        let url = Endpoints.postRatePlace

        AF.request(url, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).response { result in
            print(result)
        }
    }

    static func reratePlace(placeId: Int, rating: Int) {
        let parametrs: Parameters = [
            "rating": rating,
            "personId": UserDefaults.standard.integer(forKey: "userId"),
            "placeId": placeId
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        let url = Endpoints.reratePlace

        AF.request(url, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).response { result in
            print(result)
        }
    }

    
    static func getAllPlaceTimetable(placeId: Int, completion: @escaping (FullTimetableResponseEntity?) -> Void) {
        let url = Endpoints.getFullTimetable + String(placeId)

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: FullTimetableResponseEntity.self) { response in
            print(response)
            completion(response.value)
        }
    }
    
    
    static func getIsUserRatedPlace(placeId:Int, completion: @escaping (IsPlaceIsAssignedResponseEntity?) -> () ){
        
        let parametrs: Parameters = [
            "placeId": placeId,
            "personId": UserDefaults.standard.integer(forKey: "userId")
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]
        
        AF.request(Endpoints.getIsPlaceIsAssigned, method: .post,parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: IsPlaceIsAssignedResponseEntity.self) { response in
            print(response)
            completion(response.value)
        }
    }
}
