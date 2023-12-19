//
//  MainTabBarController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import UIKit

final class MainTabBarController: UITabBarController {
    // MARK: - Private properties

    private let mainTabBar = MainTabBar()

    // MARK: - View Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        initialize()
    }
}

private extension MainTabBarController {
    func initialize() {
        setValue(mainTabBar, forKey: "tabBar")

        setupNotifications()

        viewControllers = getViewControllers()
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(findPlaceButtonPressed), name: Notification.Name("findPlaceButtonPressed"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(findPlace), name: Notification.Name("findPlace"), object: nil)

        NotificationCenter.default.addObserver(self, selector: #selector(openPlaceOnMap), name: Notification.Name("openPlaceOnMap"), object: nil)
    }

    @objc func openPlaceOnMap() {
        selectedIndex = 1

        if let nc = viewControllers![1] as? UINavigationController {
            if let vc = nc.viewControllers.first! as? PlacesMapViewController {
                let placeIndex = UserDefaults.standard.integer(forKey: "placeIndex")
                vc.focusOnPlace(Place.basicPlaces[placeIndex])
            }
        }
    }

    @objc func findPlaceButtonPressed() {
        let viewController = FindPlacePageViewController()

        present(viewController, animated: true)
    }

    @objc func findPlace() {
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
