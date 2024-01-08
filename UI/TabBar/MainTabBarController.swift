//
//  MainTabBarController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import CoreLocation
import UIKit

final class MainTabBarController: UITabBarController {
    
    // MARK: - Private properties

    lazy private var closeScheduleGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeSchedule))
    lazy private var closeRateViewGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(closeRateView))
    
    private let mainTabBar = MainTabBar()
    private let locationManager = CLLocationManager()
    private var prevSelectedIndex = 0
    private let dimView:UIView = {
        let view = UIView(frame: UIScreen.main.bounds)
        
        view.backgroundColor = .black
        view.alpha = 0
        
        return view
    }()
    private let ratingView:RatingView = {
        let view = RatingView()
        
        view.alpha = 0
        
        return view
    }()
    
    private let scheduleView:ScheduleView = {
        let view = ScheduleView()
        
        view.alpha = 0
        
        return view
    }()
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let scheduleViewHeight:CGFloat = 310
        static let scheduleViewWidth:CGFloat = 300
        static let ratingViewHeight:CGFloat = 160
        static let ratingViewWidth:CGFloat = 300
    }

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        delegate = self
        initialize()
        getUserLocation()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        startUpdatingLocation()
    }

    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)

        stopUpdatingLocation()
    }
}

// MARK: - Private methods

private extension MainTabBarController {
    func initialize() {
        setValue(mainTabBar, forKey: "tabBar")

        navigationController?.isNavigationBarHidden = true

        setupNotifications()

        viewControllers = getViewControllers()
        
        selectedIndex = 0
        
        
    }

    func getViewControllers() -> [UIViewController] {
        let allPlacesViewController = UINavigationController(rootViewController: AllPlacesViewController())

        allPlacesViewController.tabBarItem.title = "Все места"
        allPlacesViewController.tabBarItem.image = UIImage(systemName: "magazine")
        allPlacesViewController.tabBarItem.selectedImage = UIImage(systemName: "magazine.fill")

        
        let placesMapViewController = UINavigationController(rootViewController: PlacesMapViewController())

        placesMapViewController.tabBarItem.title = "Карта"
        placesMapViewController.tabBarItem.image = UIImage(systemName: "map")
        placesMapViewController.tabBarItem.selectedImage = UIImage(systemName: "map.fill")

        let recentlyPlacesViewController = UINavigationController(rootViewController: RecentlyPlacesViewController())

        recentlyPlacesViewController.tabBarItem.title = "Недавние"
        recentlyPlacesViewController.tabBarItem.image = UIImage(systemName: "clock")
        recentlyPlacesViewController.tabBarItem.selectedImage = UIImage(systemName: "clock.fill")

        let profileViewController = UINavigationController(rootViewController: ProfileViewController())

        profileViewController.tabBarItem.title = "Профиль"
        profileViewController.tabBarItem.image = UIImage(systemName: "person")
        profileViewController.tabBarItem.selectedImage = UIImage(systemName: "person.fill")

        let spacerViewController = UIViewController()

        spacerViewController.tabBarItem.isEnabled = false

        return [allPlacesViewController, placesMapViewController, spacerViewController, recentlyPlacesViewController, profileViewController]
    }
}

// MARK: - CLLocationManagerDelegate

extension MainTabBarController: CLLocationManagerDelegate {
    func getUserLocation() {
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.requestWhenInUseAuthorization()
    }

    func startUpdatingLocation() {
        if CLLocationManager.locationServicesEnabled() {
            locationManager.startUpdatingLocation()
        }
    }

    func stopUpdatingLocation() {
        locationManager.stopUpdatingLocation()
    }

    func locationManager(_: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        guard let location = locations.last else {
            return
        }

        let latitude = location.coordinate.latitude
        let longitude = location.coordinate.longitude

        //print("Широта: \(latitude), Долгота: \(longitude)")
        UserDefaults.standard.setValue(latitude, forKey: "userLatitude")
        UserDefaults.standard.setValue(longitude, forKey: "userLongitude")
        NotificationCenter.default.post(name: Notification.Name("userLocationUpdated"), object: nil)
    }

    func locationManager(_: CLLocationManager, didFailWithError error: Error) {
        print("Ошибка получения координат: \(error.localizedDescription)")
    }
}

// MARK: - Notifications

private extension MainTabBarController {
    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(findPlaceButtonPressed), name: Notification.Name("findPlaceButtonPressed"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(findPlace), name: Notification.Name("findPlace"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openPlaceOnMap), name: Notification.Name("openPlaceOnMap"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(logout), name: Notification.Name("logout"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openNotificationsPage), name: Notification.Name("openNotificationsPage"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openSettingsPage), name: Notification.Name("openSettingsPage"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openLikedPlaces), name: Notification.Name("openLikedPlaces"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openProfileSettingsPage), name: Notification.Name("openProfileSettingsPage"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openFeedback), name: Notification.Name("openFeedback"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openSchedule), name: Notification.Name("openSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(closeSchedule), name: Notification.Name("closeSchedule"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(ratePlace), name: Notification.Name("ratePlace"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(sentRating(_:)), name: Notification.Name("sendRatePlace"), object: nil)
        
        NotificationCenter.default.addObserver(self, selector: #selector(openAllPlaces), name: Notification.Name("openAllPlaces"), object: nil)
    }
    
    @objc func ratePlace(){
        
        dimView.addGestureRecognizer(closeRateViewGestureRecognizer)
        
        view.addSubview(dimView)
        
        view.addSubview(ratingView)
        ratingView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(UIConstants.ratingViewWidth)
            make.height.equalTo(UIConstants.ratingViewHeight)
        }
        
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.3
            self.ratingView.alpha = 1
        }
        
    }
    
    @objc func sentRating(_ sender:Notification){
        let placeId = UserDefaults.standard.integer(forKey: "placeId")
        if let rating = sender.object {
            print("user rated place \(placeId): ", rating)
            
            // тут будет логика того как мы обработаем уже оценочку
            
        }
        
        closeRateView()
    }
    
    @objc func closeRateView(){
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0
            self.dimView.removeFromSuperview()
            self.ratingView.alpha = 0
            self.ratingView.removeFromSuperview()
        }
        dimView.removeGestureRecognizer(closeRateViewGestureRecognizer)
        
    }
    
    @objc func openSchedule(){
        view.addSubview(dimView)
        dimView.addGestureRecognizer(closeScheduleGestureRecognizer)
        
        
        let placeId = UserDefaults.standard.integer(forKey: "placeId")
        print(placeId) // Потом тут будет запрос на получение по айди места его расписания
        scheduleView.configure()
        
        
        
        view.addSubview(scheduleView)
        scheduleView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.width.equalTo(UIConstants.scheduleViewWidth)
            make.height.equalTo(UIConstants.scheduleViewHeight)
        }
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0.3
            self.scheduleView.alpha = 1
        }
    }
    
    @objc func closeSchedule(){
        UIView.animate(withDuration: 0.3) {
            self.dimView.alpha = 0
            self.dimView.removeFromSuperview()
            self.scheduleView.alpha = 0
            self.scheduleView.removeFromSuperview()
        }
        dimView.removeGestureRecognizer(closeScheduleGestureRecognizer)
    }

    @objc func openFeedback() {
        selectedIndex = 4
        prevSelectedIndex = 4
        
        
        if let viewController = viewControllers?.last! as? UINavigationController {
            let vc = FeedbackViewController()
            if let placeName = UserDefaults.standard.string(forKey: "placeNameToReport"){
                vc.reportPlaceName(placeName: placeName)
                UserDefaults.standard.removeObject(forKey: "placeNameToReport")
            }
            viewController.pushViewController(vc, animated: true)
        }
    }

    @objc func openProfileSettingsPage() {
        print("openProfileSettingsPage")
        selectedIndex = viewControllers!.count - 1
        prevSelectedIndex = selectedIndex
        
        if let viewController = viewControllers?.last! as? UINavigationController {
            viewController.pushViewController(ProfileSettingsViewController(), animated: true)
        }
    }

    @objc func openLikedPlaces() {
        selectedIndex = viewControllers!.count - 1
        prevSelectedIndex = selectedIndex
        if let viewController = viewControllers?.last! as? UINavigationController {
            viewController.pushViewController(FavouritePlacesViewController(), animated: true)
        }
    }

    @objc func openSettingsPage() {
        print("openSettingsPage")
        selectedIndex = viewControllers!.count - 1
        prevSelectedIndex = selectedIndex
        if let viewController = viewControllers?.last! as? UINavigationController {
            viewController.pushViewController(GlobalSettingsViewController(), animated: true)
        }
    }

    @objc func openNotificationsPage() {
        selectedIndex = viewControllers!.count - 1
        prevSelectedIndex = selectedIndex
        if let viewController = viewControllers?.last! as? UINavigationController {
            viewController.pushViewController(NotificationsViewController(), animated: true)
        }
    }

    @objc func logout() {
        print("start logout")

        let alert = UIAlertController(title: nil, message: "Вы уверены, что хотите выйти из аккаунта?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { _ in
            print("logout")
                    UserDefaults.standard.setValue(false, forKey: "isLogged")
                    UserDefaults.standard.setValue(-1, forKey: "userId")
                    self.navigationController?.setViewControllers([EnterPhoneNumViewController()], animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            print("cancel logout")
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func openPlaceOnMap() {
        selectedIndex = 1
        prevSelectedIndex = selectedIndex
        
        DispatchQueue.main.asyncAfter(deadline: .now()+0.5) {
            if let nc = self.viewControllers![1] as? UINavigationController,
               let vc = nc.viewControllers.first! as? PlacesMapViewController {
                let placeLatitude = UserDefaults.standard.double(forKey: "placeToOpenLatitude")
                let placeLongitude = UserDefaults.standard.double(forKey: "placeToOpenLongitude")
                let userId = UserDefaults.standard.integer(forKey: "userId")
                let placeId = UserDefaults.standard.integer(forKey: "placeId")
                vc.openPlaceFromPlaceVC(coord: PlaceCoordinates(latitude: placeLatitude, longitude: placeLongitude))
            }
        }
    }
    
    @objc func openAllPlaces(){
        selectedIndex = 0
        prevSelectedIndex = 0
    }

    @objc func findPlaceButtonPressed() {
        let viewController = FindPlacePageViewController()

        present(viewController, animated: true)
    }

    @objc func findPlace() {
        selectedIndex = 0
        prevSelectedIndex = selectedIndex

        let userId = UserDefaults.standard.integer(forKey: "userId")
        let placeId = UserDefaults.standard.integer(forKey: "placeId")

        RecentlyPlacesNetworkManager.makePostAddRecentlyPlaceForPersonWithIdRequest(personId: userId, placeId: placeId)

        if let vc = viewControllers?.first as? UINavigationController{
            let placeVC = PlaceViewController()

            placeVC.configureWithId(placeId)
            
            vc.pushViewController(placeVC, animated: true)
            vc.viewControllers = [vc.viewControllers.first!, vc.viewControllers.last!]
            
        }
    }
}

// MARK: - UITabBarControllerDelegate

extension MainTabBarController: UITabBarControllerDelegate {
    func tabBarController(_: UITabBarController, didSelect viewController: UIViewController) {
        if prevSelectedIndex == selectedIndex{
            if let viewController = viewController as? UINavigationController {
                viewController.navigationBar.isHidden = true
            }
        }
        prevSelectedIndex = selectedIndex
    }
}
