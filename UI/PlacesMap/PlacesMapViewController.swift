//
//  PlacesMapViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 13.12.23.
//

import MapKit
import UIKit
import YandexMapsMobile
import SnapKit


final class PlacesMapViewController: UIViewController {
    
    // MARK: - Public

    
    
    func openPlaceFromPlaceVC(coord:PlaceCoordinates){
        createAllPlacesPlacemarks(map: mapView.mapWindow.map)
        hideBottomView()
        bottomView.showAllPlaces()
        focusOn(coordinates: coord, zoom:16)
    }
    

    // MARK: - Livecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }
    

    // MARK: - Private constants

    private var place = GetAllPlacesRequestResponseSingleEntity(id: 0, nameOfPlace: "", description: "", photos: [], longitude: 0, latitude: 0, types: [])

    private let belarusCoordinates = PlaceCoordinates(latitude: 53.902735, longitude: 27.555691)
    private var placemarks:[YMKMapObject] = []

    private enum UIConstants {
        static let meButtonLeadingOffset: CGFloat = 20
        static let meButtonBottomInset: CGFloat = 30
        static let bottomViewHeight:CGFloat = 270
    }

    // MARK: - Private properties

    private let mapView = YMKMapView()
    private var userPlacemark: YMKPlacemarkMapObject!
    
    private let bottomView:MapBottomView = MapBottomView()
    private var bottomViewBottomConstraint: Constraint!
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
        mapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideOrShowBottomView)))
        createUserPlacemark()
        setupNotifications()

        
        view.addSubview(bottomView)
        
        bottomView.snp.makeConstraints { make in
            make.width.centerX.equalToSuperview()
            make.height.equalTo(UIConstants.bottomViewHeight)
            bottomViewBottomConstraint = make.bottom.equalToSuperview().constraint
        }
        
        focusOn(coordinates: belarusCoordinates, zoom:6)
        createAllPlacesPlacemarks(map: mapView.mapWindow.map)
        bottomView.showAllPlaces()
        hideBottomView()
    }
    
    
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

    @objc func focusOnUserLocation() {
        let userLat = UserDefaults.standard.double(forKey: "userLatitude")
        let userLong = UserDefaults.standard.double(forKey: "userLongitude")
        
        hideBottomView()

        focusOn(coordinates: PlaceCoordinates(latitude: userLat, longitude: userLong), zoom: 15)
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(updateUserLocation), name: Notification.Name("userLocationUpdated"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(focusOnUserLocation), name: Notification.Name("focusOnUserLocation"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(changePlaceTypeOnMap(_:)), name: Notification.Name("changePlaceTypeOnMap"), object: nil)
    }
    
    @objc func changePlaceTypeOnMap(_ sender:Notification){
        guard let type = sender.object as? PlacesToFocusType else {return}
        showBottomView()
        switch type{
        case .all:
            focusOn(coordinates: belarusCoordinates, zoom: 6)
            createAllPlacesPlacemarks(map: mapView.mapWindow.map)
        case .nearby:
            focusOnUserLocation()
            createPlacesNearbyPlacemarks(map: mapView.mapWindow.map)
        case .recently:
            focusOn(coordinates: belarusCoordinates, zoom: 6)
            removeAllPlacemarks(map: mapView.mapWindow.map)
            createRecentlyPlacesPlacemarks(map: mapView.mapWindow.map)
        case .favourite:
            focusOn(coordinates: belarusCoordinates, zoom: 6)
            removeAllPlacemarks(map: mapView.mapWindow.map)
            createFavouritePlacesPlacemarks(map: mapView.mapWindow.map)
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
    
    func removeAllPlacemarks(map:YMKMap){
        for placemark in placemarks {
            map.mapObjects.remove(with: placemark)
        }
        placemarks = []
    }
    
    func createRecentlyPlacesPlacemarks(map: YMKMap){
        let userId = UserDefaults.standard.integer(forKey: "userId")
        RecentlyPlacesNetworkManager.makeGetRecentlyPlacesForPersonWithIdRequest(id: userId) { [self] responseEntity in
            if let places = responseEntity {
                if !(places.recentlyPlaces.count == 0){
                    removeAllPlacemarks(map: map)
                    for place in places.recentlyPlaces {
                        addPlacemark(map, place)
                    }
                } else{
                    hideBottomView()
                    let alert = UIAlertController(title: "Нет недавних", message: "Не хотите перейти в каталог мест и посмотреть несколько мест там?", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Перейти", style: .default, handler: { _ in
                        NotificationCenter.default.post(name: Notification.Name("openAllPlaces"), object: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func createFavouritePlacesPlacemarks(map: YMKMap){
        let userId = UserDefaults.standard.integer(forKey: "userId")
        FavouritePlacesNetworkManager.getFavouritePlacesForUser(id: userId) { [self] responseEntity in
            if let places = responseEntity{
                if !(places.favPlaces.count == 0){
                    removeAllPlacemarks(map: map)
                    for place in places.favPlaces {
                        addPlacemark(map, place)
                    }
                } else{
                    hideBottomView()
                    let alert = UIAlertController(title: "Нет любимых", message: "Не хотите перейти в каталог мест и найти любимые там?", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Перейти", style: .default, handler: { _ in
                        NotificationCenter.default.post(name: Notification.Name("openAllPlaces"), object: nil)
                    }))
                    alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    func createPlacesNearbyPlacemarks(map: YMKMap){
        showBottomView()
        PlacesNetworkManager.getAllPlacesRequest { [self] responseEntity in
            if var places = responseEntity {
                places = DistantionCalculator.shared.findPlacesNearby(places: places)
                
                if !(places.count == 0){
                    removeAllPlacemarks(map: map)
                    for place in places{
                        addPlacemark(map, place)
                    }
                } else{
                    hideBottomView()
                    let alert = UIAlertController(title: "Упс!", message: "Не можем найти места поблизости", preferredStyle: .alert)

                    alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel, handler: nil))
                    
                    present(alert, animated: true, completion: nil)
                }
            }
        }
    }
    
    

    func createAllPlacesPlacemarks(map: YMKMap) {
        removeAllPlacemarks(map: map)
        PlacesNetworkManager.getAllPlacesRequest { [self] responseEntity in
            if let places = responseEntity {
                for place in places {
                    addPlacemark(map, place)
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
        placemarks.append(placemark)
    }
    
    @objc func showBottomView(){
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(0)
            }
        }
        isBottomViewHidden = false
    }
    
    @objc func hideBottomView(){
        UIView.animate(withDuration: 0.3) {
            self.bottomView.snp.updateConstraints { make in
                make.bottom.equalToSuperview().offset(210)
            }
            self.bottomView.layoutIfNeeded()
        }
        isBottomViewHidden = true
    }
    
    @objc func hideOrShowBottomView(){
        if isBottomViewHidden{
            showBottomView()
        } else{
            hideBottomView()
        }
    }
    
    
}
