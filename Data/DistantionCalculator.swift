//
//  DistantionCalculator.swift
//  placeby
//
//  Created by Timur Gazizulin on 30.12.23.
//

import Foundation

final class DistantionCalculator {
    
    static let shared = DistantionCalculator()
    
    private init(){}
    
    func calculateDistanceFromUser( _ coord:PlaceCoordinates) -> Double {
        let earthRadius = 6371.0
        
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLon = UserDefaults.standard.double(forKey: "userLongitude")
        
        let lat1Rad = userLat * .pi / 180.0
        let lon1Rad = userLon * .pi / 180.0
        let lat2Rad = coord.latitude * .pi / 180.0
        let lon2Rad = coord.longitude * .pi / 180.0
        
        let deltaLon = lon2Rad - lon1Rad
        
        let distance = 2 * asin(sqrt(
            pow(sin((lat2Rad - lat1Rad) / 2), 2) +
            cos(lat1Rad) * cos(lat2Rad) * pow(sin(deltaLon / 2), 2)
        ))
        
        let distanceInKm = distance * earthRadius
        
        
        return distanceInKm
    }
    
    func findPlacesNearby(places:GetAllPlacesRequestResponseEntity) -> GetAllPlacesRequestResponseEntity{
        var placesNearby:GetAllPlacesRequestResponseEntity = []
        
        let placesNearbyRange:Double = 20
        
        for place in places{
            let distance = DistantionCalculator.shared.calculateDistanceFromUser(PlaceCoordinates(latitude: place.latitude, longitude: place.longitude))
            
            if distance <= placesNearbyRange{
                placesNearby.append(place)
            }
        }
        return placesNearby
    }
    
}

extension Double {
    func rounded(toDecimalPlaces decimalPlaces: Int) -> Double {
        let multiplier = pow(10.0, Double(decimalPlaces))
        return (self * multiplier).rounded() / multiplier
    }
}
