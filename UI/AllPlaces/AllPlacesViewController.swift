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

    private let data: [AllPlacesTableViewCellType] = {
        var data = [AllPlacesTableViewCellType]()

        data.append(.title)

        for place in Place.basicPlaces {
            data.append(.place(place))
        }

        return data
    }()

    // MARK: - Private properties

    private lazy var tableView: AllPlacesTableView = {
        let tableView = AllPlacesTableView()
        tableView.dataSource = self

        return tableView
    }()
}

// MARK: - Private methods

private extension AllPlacesViewController {
    func initialization() {
        navigationController?.navigationBar.isHidden = true
        view.backgroundColor = .white

        setupNotifications()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(findPlace), name: Notification.Name("findPlace"), object: nil)
    }

    @objc func findPlace() {
        let vc = PlaceViewController()

        vc.configure(with: Place.basicPlaces.randomElement()!)

        navigationController?.pushViewController(vc, animated: true)
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
        case .title:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: TitleCell.self), for: indexPath) as! TitleCell

            return cell
        case let .place(place):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceCell.self), for: indexPath) as! PlaceCell

            cell.configure(with: place)

            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToPlace(_:))))

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
