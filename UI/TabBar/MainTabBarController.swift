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

    private let mainTabBar = MainTabBar()
    private let locationManager = CLLocationManager()
    private var prevSelectedIndex = 0

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
    }

    @objc func openFeedback() {
        if let url = URL(string: "https://youtu.be/dQw4w9WgXcQ?si=dzF_cgAxz2dXJ12D") {
            UIApplication.shared.open(url)
        }
    }

    @objc func openProfileSettingsPage() {
        print("openProfileSettingsPage")
        selectedIndex = viewControllers!.count - 1
    }

    @objc func openLikedPlaces() {
        print("openLikedPlaces")
        selectedIndex = viewControllers!.count - 1

//        if let viewController = viewControllers?.last! as? UINavigationController {
//            //viewController.pushViewController(UIViewController(), animated: true)
//        }
    }

    @objc func openSettingsPage() {
        print("openSettingsPage")
        selectedIndex = viewControllers!.count - 1

//        if let viewController = viewControllers?.last! as? UINavigationController {
//            //viewController.pushViewController(UIViewController(), animated: true)
//        }
    }

    @objc func openNotificationsPage() {
        print("openNotificationsPage")
        selectedIndex = viewControllers!.count - 1

        if let viewController = viewControllers?.last! as? UINavigationController {
            viewController.pushViewController(NotificationsViewController(), animated: true)
        }
    }

    @objc func logout() {
        print("start logout")

        let alert = UIAlertController(title: nil, message: "Вы уверены, что хотите выйти из аккаунта?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { _ in
            print("logout")
            //        UserDefaults.standard.setValue(false, forKey: "isLogged")
            //        UserDefaults.standard.setValue(-1, forKey: "userId")
            //        self.navigationController?.setViewControllers([EnterPhoneNumViewController()], animated: true)
        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            print("cancel logout")
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func openPlaceOnMap() {
        selectedIndex = 1

        if let nc = viewControllers![1] as? UINavigationController {
            if let vc = nc.viewControllers.first! as? PlacesMapViewController {
                let placeLatitude = UserDefaults.standard.double(forKey: "placeToOpenLatitude")
                let placeLongitude = UserDefaults.standard.double(forKey: "placeToOpenLongitude")
                vc.focusOn(coordinates: PlaceCoordinates(latitude: placeLatitude, longitude: placeLongitude))
            }
        }
    }

    @objc func findPlaceButtonPressed() {
        let viewController = FindPlacePageViewController()

        present(viewController, animated: true)
    }

    @objc func findPlace() {
        selectedIndex = 0

        let userId = UserDefaults.standard.integer(forKey: "userId")
        let placeId = UserDefaults.standard.integer(forKey: "placeId")

        RecentlyPlacesNetworkManager.makePostAddRecentlyPlaceForPersonWithIdRequest(personId: userId, placeId: placeId)

        if let vc = viewControllers?.first as? UINavigationController{
            let placeVC = PlaceViewController()

            placeVC.configureWithId(placeId)
            
            vc.pushViewController(placeVC, animated: true)
            
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
