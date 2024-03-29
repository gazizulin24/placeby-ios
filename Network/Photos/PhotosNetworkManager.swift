//
//  PhotosNetworkManager.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import Alamofire

enum PhotosNetworkManager {
    static func loadPhoto(url: String, completion: @escaping (Data?) -> Void) {
        if let url = URL(string: url) {
            AF.request(url).responseData { response in
                if let data = response.data {
                    completion(data)
                }
            }
        }
    }
}
