//
//  RecentlyPlacesNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import Alamofire

final class RecentlyPlacesNetworkManager {
    private enum Endpoints {
        static let getRecentlyPlacesForPersonWithId = GlobalNetworkConstants.host + "/people/recentlyPlaces/"
        static let deleteRecentlyPlacesForPersonWithId = GlobalNetworkConstants.host + "/people/recentlyPlaces"
        static let postAddRecentlyPlaceToUser = GlobalNetworkConstants.host + "/people/recentlyPlaces"
    }

    static func makeGetRecentlyPlacesForPersonWithIdRequest(id: Int, completion: @escaping (GetRecentlyPlacesResponseEntity?) -> Void) {
        let url = Endpoints.getRecentlyPlacesForPersonWithId + String(id)

        AF.request(url, method: .get, encoding: JSONEncoding.default).responseDecodable(of: GetRecentlyPlacesResponseEntity.self) { response in
            print(response)
            completion(response.value)
        }
    }

    static func makeDeleteRecentlyPlacesForPersonWithIdRequest(id: Int, completion: @escaping (DeleteAllRecentlyPlacesResponseEntity?) -> Void) {
        let parametrs: Parameters = [
            "personId": id,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.deleteRecentlyPlacesForPersonWithId, method: .delete, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: DeleteAllRecentlyPlacesResponseEntity.self) { response in
            completion(response.value)
        }
    }

    static func makePostAddRecentlyPlaceForPersonWithIdRequest(personId: Int, placeId: Int) {
        let parametrs: Parameters = [
            "personId": personId,
            "placeId": placeId,
        ]
        let headers: HTTPHeaders = [
            "Content-Type": "application/json",
        ]

        AF.request(Endpoints.postAddRecentlyPlaceToUser, method: .post, parameters: parametrs, encoding: JSONEncoding.default, headers: headers).responseDecodable(of: DeleteAllRecentlyPlacesResponseEntity.self) { response in
            print(response.response?.statusCode as Any)
        }
    }
}
