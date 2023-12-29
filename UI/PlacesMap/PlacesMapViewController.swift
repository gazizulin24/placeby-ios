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
    // MARK: - Public

    func focusOnPlace(_ place: Place) {
        self.place = place
        // addPlacemark(mapView.mapWindow.map, place)
        focusOn(coordinates: place.coordinates)
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

    // MARK: - Livecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private var place = Place(placeId: 0, name: "", description: "", distantion: "", images: [], coordinates: PlaceCoordinates(latitude: 0, longitude: 0))

    private let belarusCoordinates = PlaceCoordinates(latitude: 53.902735, longitude: 27.555691)

    private enum UIConstants {
        static let meButtonSize: CGFloat = 50
        static let meButtonLeadingOffset: CGFloat = 20
        static let meButtonBottomInset: CGFloat = 30
    }

    // MARK: - Private properties

    private let mapView = YMKMapView()
    private var userPlacemark: YMKPlacemarkMapObject!

    private lazy var meButton: UIButton = {
        let button = UIButton()

        button.setTitle("Вы", for: .normal)

        button.backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.setTitleColor(UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1)), for: .normal)
        button.addTarget(self, action: #selector(focusOnUserLocation), for: .touchUpInside)

        button.layer.cornerRadius = UIConstants.meButtonSize / 2
        button.layer.borderWidth = 3
        button.layer.borderColor = CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1)

        return button
    }()
}

// MARK: - Private methods

private extension PlacesMapViewController {
    func initialization() {
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }
        createUserPlacemark()
        setupNotifications()

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

        mapView.addSubview(meButton)

        meButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIConstants.meButtonLeadingOffset)
            make.bottom.equalToSuperview().inset(UIConstants.meButtonBottomInset)
            make.size.equalTo(UIConstants.meButtonSize)
        }

        createAllPlacesPlacemarks(map: mapView.mapWindow.map)
    }

    @objc func focusOnUserLocation() {
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLong = UserDefaults.standard.double(forKey: "userLongitude")

        focusOn(coordinates: PlaceCoordinates(latitude: userLat, longitude: userLong))
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserLocation), name: Notification.Name("userLocationUpdated"), object: nil)
    }

    func updateUserPlacemark(lat: Double, long: Double) {
        print("пересоздал юзер плейсмарк")
        guard let userPlacemark = userPlacemark else {
            return
        }

        let newCoordinate = YMKPoint(latitude: lat, longitude: long)

        // Устанавливаем новые координаты для существующего userPlacemark
        userPlacemark.geometry = newCoordinate
    }

    func createAllPlacesPlacemarks(map: YMKMap) {
        PlacesNetworkManager.getAllPlacesRequest { [self] responseEntity in
            if let responseEntity = responseEntity {
                for placeResponseEntity in responseEntity {
                    let singlePlace = Place(placeId: placeResponseEntity.id, name: placeResponseEntity.nameOfPlace, description: placeResponseEntity.description, distantion: "", images: [], coordinates: PlaceCoordinates(latitude: placeResponseEntity.latitude, longitude: placeResponseEntity.longitude))
                    self.addPlacemark(map, singlePlace)
                }
            } else {
                for place in Place.basicPlaces {
                    self.addPlacemark(map, place)
                }
            }
        }
    }

    func createUserPlacemark() {
        userPlacemark = mapView.mapWindow.map.mapObjects.addPlacemark()
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLong = UserDefaults.standard.double(forKey: "userLongitude")
        userPlacemark.geometry = YMKPoint(latitude: userLat, longitude: userLong)
        userPlacemark.setTextWithText(
            "Вы",
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

        userPlacemark.setIconWith(UIImage(named: "placemark_icon") ?? UIImage(systemName: "person")!)
    }

    @objc func updateUserLocation() {
        print("обновляю юзер локейшн")
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLong = UserDefaults.standard.double(forKey: "userLongitude")

        updateUserPlacemark(lat: userLat, long: userLong)
    }

    func addPlacemark(_ map: YMKMap, _ place: Place) {
        print(place)
        let image = UIImage(named: "placemark_icon") ?? UIImage(systemName: "person")!
        let placemark = map.mapObjects.addPlacemark()
        placemark.geometry = YMKPoint(latitude: place.coordinates.latitude,
                                      longitude: place.coordinates.longitude)

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
