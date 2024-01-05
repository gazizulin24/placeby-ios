//
//  FavouritePlacesNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import Alamofire

final class FavouritePlacesNetworkManager {
    private enum Endpoints {
        static let getFavouritePlacesForPerson = GlobalNetworkConstants.host + "/people/favPlaces/"
        static let addPlaceToFavouriteEndpoint = GlobalNetworkConstants.host + "/people/favPlaces"
        static let deleteFavouritePlaceForUser = GlobalNetworkConstants.host + "/people/favPlaces"
    }
    
    
    static func getFavouritePlacesForUser(id:Int, completion: @escaping (GetFavouritePlacesResponseEntity?) -> ()) {
        
        let url = Endpoints.getFavouritePlacesForPerson + String(id)

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetFavouritePlacesResponseEntity.self) { response in
            print(response)
            completion(response.value)
        }
    }
    
    
    static func makePlaceFavouriteForPerson(placeId:Int, personId:Int) {
        let parametrs: Parameters = [
            "personId": personId,
            "placeId": placeId,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.addPlaceToFavouriteEndpoint, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).response() { result in
            print(result)
        }
        
    }
    
    
    static func deleteFavouritePlaceForUser(placeId:Int, personId:Int) {
        let parametrs: Parameters = [
            "personId": personId,
            "placeId": placeId,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.deleteFavouritePlaceForUser, method: .delete, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).response() { result in
            print(result)
        }
        
    }
}
