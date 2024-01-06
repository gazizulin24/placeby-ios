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

    func focusOnPlace(_ place: GetAllPlacesRequestResponseSingleEntity) {
        self.place = place
        focusOn(coordinates: PlaceCoordinates(latitude: place.latitude, longitude: place.longitude), zoom: 6)
    }

    func focusOn(coordinates coord: PlaceCoordinates, zoom:Float = 11) {
        mapView.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: coord.latitude, longitude: coord.longitude),
                zoom: zoom,
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
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        hideBottomView()
        focusOn(coordinates: belarusCoordinates, zoom:6)
        createAllPlacesPlacemarks(map: mapView.mapWindow.map)
    }

    // MARK: - Private constants

    private var place = GetAllPlacesRequestResponseSingleEntity(id: 0, nameOfPlace: "", description: "", photos: [], longitude: 0, latitude: 0, types: [])

    private let belarusCoordinates = PlaceCoordinates(latitude: 53.902735, longitude: 27.555691)

    private enum UIConstants {
        static let meButtonSize: CGFloat = 50
        static let meButtonLeadingOffset: CGFloat = 20
        static let meButtonBottomInset: CGFloat = 30
        static let bottomViewHeight:CGFloat = 270
    }

    // MARK: - Private properties

    private let mapView = YMKMapView()
    private var userPlacemark: YMKPlacemarkMapObject!
    
    private let bottomView:MapBottomView = MapBottomView()
    private var isBottomViewHidden = false
}

// MARK: - Private methods

private extension PlacesMapViewController {
    func initialization() {
        view.addSubview(mapView)

        mapView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.size.equalToSuperview()
        }
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideBottomView)))
        createUserPlacemark()
        setupNotifications()

//        mapView.addSubview(meButton)
//
//        meButton.snp.makeConstraints { make in
//            make.leading.equalToSuperview().offset(UIConstants.meButtonLeadingOffset)
//            make.bottom.equalToSuperview().inset(UIConstants.meButtonBottomInset)
//            make.size.equalTo(UIConstants.meButtonSize)
//        }
        
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.bottom.width.centerX.equalToSuperview()
            make.height.equalTo(UIConstants.bottomViewHeight)
        }
        
       
    }

    @objc func focusOnUserLocation() {
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLong = UserDefaults.standard.double(forKey: "userLongitude")

        focusOn(coordinates: PlaceCoordinates(latitude: userLat, longitude: userLong), zoom: 15)
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserLocation), name: Notification.Name("userLocationUpdated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(focusOnUserLocation), name: Notification.Name("focusOnUserLocation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePlaceTypeOnMap(_:)), name: Notification.Name("changePlaceTypeOnMap"), object: nil)
    }
    
    @objc func changePlaceTypeOnMap(_ sender:Notification){
        guard let type = sender.object as? PlacesToFocusType else {return}
        
        switch type{
        case .all:
            focusOn(coordinates: belarusCoordinates, zoom: 6)
//            mapView.mapWindow.map.mapObjects.addPlace()
        case .nearby:
            print(type)
        case .recently:
            print(type)
        case .favourite:
            print(type)
        }
    }

    func updateUserPlacemark(lat: Double, long: Double) {
        //print("пересоздал юзер плейсмарк")
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
                    self.addPlacemark(map, placeResponseEntity)
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
        //print("обновляю юзер локейшн")
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLong = UserDefaults.standard.double(forKey: "userLongitude")

        updateUserPlacemark(lat: userLat, long: userLong)
    }

    func addPlacemark(_ map: YMKMap, _ place: GetAllPlacesRequestResponseSingleEntity) {
        //print(place)
        let image = UIImage(named: "placemark_icon") ?? UIImage(systemName: "person")!
        let placemark = map.mapObjects.addPlacemark()
        placemark.geometry = YMKPoint(latitude: place.latitude,
                                      longitude: place.longitude)

        placemark.setTextWithText(
            place.nameOfPlace,
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
    
    @objc func hideBottomView(){
        if isBottomViewHidden{
            UIView.animate(withDuration: 0.2){
                self.bottomView.frame.origin.y -= 210
            }
            isBottomViewHidden = false
        } else{
            UIView.animate(withDuration: 0.2){
                self.bottomView.frame.origin.y += 210
            }
            isBottomViewHidden = true
        }
    }
}
