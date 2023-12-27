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
        for place in Place.basicPlaces {
            data.append(.place(place))
        }

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
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(findPlace), name: Notification.Name("findPlace"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(filterPlaces), name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }
    
    @objc func filterPlaces(){
        if let placeType = PlaceType.getPlaceTypeFromUserDefaults(){
            filterTableView(with:placeType)
        }
    }

    @objc func findPlace() {
        let vc = PlaceViewController()

        vc.configure(with: Place.basicPlaces.randomElement()!)

        navigationController?.pushViewController(vc, animated: true)
    }
    
    func filterTableView(with placeType:PlaceType){
        data = []
        data.append(.placeTypes)
        if placeType.dbTitle == "all"{
            data.append(.recomendations)
        }
        data.append(.title(placeType.title))
        data.append(.loading)
        tableView.reloadData()
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

            cell.configure(with: place)

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

            return cell
        }
    }

    @objc func tapToPlace(_ sender: UITapGestureRecognizer) {
        if let view = sender.view as? PlaceCell {
            let placeVC = PlaceViewController()

            placeVC.configure(with: view.place)

            navigationController?.pushViewController(placeVC, animated: true)
        }
    }
}

// MARK: - UITableViewDelegate
extension AllPlacesViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        cell.alpha = 0
        
        if let cell = cell as? PlaceTypesCell {
            cell.alpha = 1
        } else{
            UIView.animate(withDuration: 0.3) {
                cell.alpha = 1
            }
        }
    }
}
