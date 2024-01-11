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

    private let recomendationsData = [RecomendationsSingleData(title: "Знаковые места", imageName: "znakovoe-mesto", placesType: "attractions"), RecomendationsSingleData(title: "Парой", imageName: "pair", placesType: "pair"), RecomendationsSingleData(title: "Cемьей", imageName: "family", placesType: "family")]

    private lazy var data: [AllPlacesTableViewCellType] = {
        var data = [AllPlacesTableViewCellType]()

        data.append(.placeTypes)

        data.append(.recomendations(recomendationsData))
        data.append(.title("Все"))

        data.append(.loading)

        return data
    }()

    // MARK: - Private constants

    private enum UIConstants {
        static let buttonSize: CGFloat = 50
    }

    // MARK: - Private properties

    private lazy var tableView: AllPlacesTableView = {
        let tableView = AllPlacesTableView()
        tableView.dataSource = self
        tableView.delegate = self

        return tableView
    }()

    private lazy var upButton: UIButton = {
        let button = UIButton()

        button.addTarget(self, action: #selector(scrollTableViewUp), for: .touchUpInside)

        button.setImage(UIImage(systemName: "chevron.up")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        button.layer.cornerRadius = UIConstants.buttonSize / 2
        button.backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        // button.layer.borderWidth = 1

        button.alpha = 0

        button.isEnabled = false
        return button
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

        view.addSubview(upButton)

        upButton.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(20)
            make.bottom.equalToSuperview().inset(20)
            make.size.equalTo(UIConstants.buttonSize)
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

    @objc func scrollTableViewUp() {
        tableView.scrollToRow(at: IndexPath(row: 0, section: 0), at: .top, animated: true)
    }

    func turnOnUpButton() {
        if upButton.isEnabled { return }

        UIView.animate(withDuration: 0.3) {
            self.upButton.alpha = 1
        }

        upButton.isEnabled = true
    }

    func turnOffUpButton() {
        if !upButton.isEnabled { return }

        UIView.animate(withDuration: 0.3) {
            self.upButton.alpha = 0
        }

        upButton.isEnabled = false
    }

    func filterTableView(with placeType: PlaceType) {
        data = []
        data.append(.placeTypes)
        if placeType.dbTitle == "all" {
            data.append(.recomendations(recomendationsData))
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
                        data.append(.place(placeResponse))
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
            PlacesNetworkManager.getAllPlacesByTypeRequest(filter) { [self] responseEntity in
                data.removeLast()
                if let responseEntity = responseEntity {
                    for placeResponse in responseEntity {
                        data.append(.place(placeResponse))
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

            cell.configure(with: place)

            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToPlace(_:))))
            return cell
        case let .recomendations(recomendationsData):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecomendationsCell.self), for: indexPath) as! RecomendationsCell
            cell.configure(with: recomendationsData)

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
            UserDefaults.standard.setValue(view.placeId, forKey: "placeId")
            NotificationCenter.default.post(name: Notification.Name("findPlace"), object: nil)
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

    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let contentOffsetY = scrollView.contentOffset.y
        // print(contentOffsetY)
        if contentOffsetY > 300 {
            turnOnUpButton()
        } else if contentOffsetY < 300 {
            turnOffUpButton()
        }
    }
}
