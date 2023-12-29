//
//  AllPlacesViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import SnapKit
import UIKit

final class AllPlacesViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        // navigationItem.title = "Все места"
        initialization()
    }

    // MARK: - Private constants

    private var data: [AllPlacesTableViewCellType] = {
        var data = [AllPlacesTableViewCellType]()

        data.append(.placeTypes)

        data.append(.recomendations)
        data.append(.title("Все"))

        data.append(.loading)

        return data
    }()

    // MARK: - Private properties

    private lazy var tableView: AllPlacesTableView = {
        let tableView = AllPlacesTableView()
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()
}

// MARK: - Private methods

private extension AllPlacesViewController {
    func initialization() {
        navigationController?.navigationBar.isHidden = true
        navigationController?.navigationBar.barTintColor = .white
        view.backgroundColor = .white

        setupNotifications()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        UserDefaults.standard.setValue("all", forKey: "allPlacesFilterDBTitle")
        addPlacesToDataByFilter(by: "all")
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(filterPlaces), name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }

    @objc func filterPlaces() {
        if let placeType = PlaceType.getPlaceTypeFromUserDefaults() {
            filterTableView(with: placeType)
        }
    }

    func filterTableView(with placeType: PlaceType) {
        data = []
        data.append(.placeTypes)
        if placeType.dbTitle == "all" {
            data.append(.recomendations)
        }
        data.append(.title(placeType.title))
        data.append(.loading)
        tableView.reloadData()
        addPlacesToDataByFilter(by: UserDefaults.standard.string(forKey: "allPlacesFilterDBTitle") ?? "all")
    }

    func addPlacesToDataByFilter(by filter: String) {
        if filter == "all" {
            PlacesNetworkManager.getAllPlacesRequest { [self] responseEntity in
                data.removeLast()
                if let responseEntity = responseEntity {
                    for placeResponse in responseEntity {
                        print(placeResponse.types)
                        let place = Place(placeId: placeResponse.id, name: placeResponse.nameOfPlace, description: placeResponse.description, distantion: placeResponse.photos.first!.photoURL, images: [], coordinates: PlaceCoordinates(latitude: placeResponse.latitude, longitude: placeResponse.longitude))
                        data.append(.place(place))
                    }
                } else {
                    print("no data")
                }
                if data.count == 3 {
                    data.append(.smallTitle("Тут пусто 😟"))
                }
                tableView.reloadData()
            }
        } else {
            print("get places with filter:", filter)
            PlacesNetworkManager.getAllPlacesByTypeRequest(filter) { [self] responseEntity in
                data.removeLast()
                if let responseEntity = responseEntity {
                    for placeResponse in responseEntity {
                        print(placeResponse.types)
                        let place = Place(placeId: placeResponse.id, name: placeResponse.nameOfPlace, description: placeResponse.description, distantion: placeResponse.photos.first!.photoURL, images: [], coordinates: PlaceCoordinates(latitude: placeResponse.latitude, longitude: placeResponse.longitude))
                        data.append(.place(place))
                    }
                } else {
                    print("no data")
                }
                if data.count == 2 {
                    data.append(.smallTitle("Тут пусто 😟"))
                }
                tableView.reloadData()
            }
        }
    }
}

// MARK: - UITableViewDataSource

extension AllPlacesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        switch data[index] {
        case let .title(title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self), for: indexPath) as! TitleCell
            cell.configure(with: title)
            return cell
        case let .place(place):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceCell.self), for: indexPath) as! PlaceCell

            if place.images.isEmpty {
                print(place.distantion)
                cell.configureWithPhotoUrl(place: place, photoUrl: place.distantion)
            } else {
                cell.configure(with: place)
            }

            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToPlace(_:))))
            return cell
        case .recomendations:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecomendationsCell.self), for: indexPath) as! RecomendationsCell
            cell.configure()

            return cell
        case .placeTypes:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceTypesCell.self), for: indexPath) as! PlaceTypesCell

            return cell
        case .loading:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: LoadingCell.self), for: indexPath) as! LoadingCell

            cell.reloadIndicator()
            return cell
        case let .smallTitle(title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmallTitleCell.self), for: indexPath) as! SmallTitleCell

            cell.configure(with: title)

            return cell
        }
    }

    @objc func tapToPlace(_ sender: UITapGestureRecognizer) {
        if let view = sender.view as? PlaceCell {
            let placeVC = PlaceViewController()

            let place = view.place

            print("place: ", place.images.isEmpty)

            UserDefaults.standard.setValue(place.placeId, forKey: "placeId")
            NotificationCenter.default.post(name: Notification.Name("findPlace"), object: nil)

            if place.images.isEmpty {
                placeVC.configureWithImageUrl(place: place, imageUrl: place.distantion)
            } else {
                placeVC.configure(with: view.place)
            }

            navigationController?.pushViewController(placeVC, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate

extension AllPlacesViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        if let cell = cell as? PlaceTypesCell {
            cell.alpha = 1
        } else {
            UIView.animate(withDuration: 0.3) {
                cell.alpha = 1
            }
        }
    }
}
