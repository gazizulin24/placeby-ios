//
//  PlacesMapViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 13.12.23.
//

import MapKit
import UIKit
import YandexMapsMobile

final class PlacesMapViewController: UIViewController {
    func focusOnPlace(_ place: Place) {
        self.place = place
        // addPlacemark(mapView.mapWindow.map, place)
        focusOn(coordinates: place.coordinates)
    }

    // MARK: - Livecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private var place = Place(name: "", description: "", distantion: "", images: [], coordinates: PlaceCoordinates(latitude: 0, longitude: 0))

    private let belarusCoordinates = PlaceCoordinates(latitude: 53.902735, longitude: 27.555691)

    // MARK: - Private properties

    private let mapView = YMKMapView()
}

// MARK: - Private methods

private extension PlacesMapViewController {
    func initialization() {
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }

        if place.name == "" {
            mapView.mapWindow.map.move(
                with: YMKCameraPosition(
                    target: YMKPoint(latitude: belarusCoordinates.latitude, longitude: belarusCoordinates.longitude),
                    zoom: 6,
                    azimuth: 0,
                    tilt: 0
                ),
                animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 0),
                cameraCallback: nil
            )
        }

        for place in Place.basicPlaces {
            addPlacemark(mapView.mapWindow.map, place)
        }
    }

    func focusOn(coordinates coord: PlaceCoordinates) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: coord.latitude, longitude: coord.longitude),
                zoom: 17,
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil
        )
    }

    func addPlacemark(_ map: YMKMap, _ place: Place) {
        let image = UIImage(named: "placemark_icon") ?? UIImage(systemName: "person")!
        let placemark = map.mapObjects.addPlacemark()
        placemark.geometry = YMKPoint(latitude: place.coordinates.latitude, longitude: place.coordinates.longitude)

        placemark.setTextWithText(
            place.name,
            style: YMKTextStyle(
                size: 10.0,
                color: .black,
                outlineColor: .white,
                placement: .top,
                offset: 0.0,
                offsetFromIcon: true,
                textOptional: false
            )
        )

        placemark.setIconWith(image)
    }
}
