//
//  RecentlyPlacesViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import SnapKit
import UIKit

final class RecentlyPlacesViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialize()
    }

    // MARK: - Private properties

    private lazy var refresh: UIRefreshControl = {
        let refresh = UIRefreshControl()
        refresh.tintColor = .black
        refresh.addTarget(self, action: #selector(refreshRecentlyPlacesAction), for: .valueChanged)
        return refresh
    }()

    private var data: [RecentlyPlacesTableViewCellType] = {
        var data = [RecentlyPlacesTableViewCellType]()

        // data.append(.title("Тут пусто 😟"))

        return data
    }()

    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Недавние"
        label.font = .systemFont(ofSize: 35, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()

    private lazy var tableView: RecentlyPlacesTableView = {
        let tableView = RecentlyPlacesTableView()

        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

// MARK: - Private methods

private extension RecentlyPlacesViewController {
    func initialize() {
        view.backgroundColor = .white
        navigationItem.titleView = titleLabelView

        configNavigation()

        view.addSubview(tableView)
        tableView.addSubview(refresh)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }

        refreshRecentlyPlacesAction()
    }

    func configNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.rightBarButtonItems = getRightBarButtonItems()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.titleView = titleLabelView
    }

    func getRightBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(clearRecentlyPlaces)))

        return items
    }

    @objc func clearRecentlyPlaces() {
        let alert = UIAlertController(title: nil, message: "Очистить недавно просмотренные места?", preferredStyle: .alert)

        alert.addAction(UIAlertAction(title: "Да", style: .destructive, handler: { _ in
            print("clear")

            self.removeRecentlyPlaces()

        }))
        alert.addAction(UIAlertAction(title: "Отмена", style: .cancel, handler: { _ in
            print("cancel")
        }))
        present(alert, animated: true, completion: nil)
    }

    @objc func removeRecentlyPlaces() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        RecentlyPlacesNetworkManager.makeDeleteRecentlyPlacesForPersonWithIdRequest(id: userId) { [self] responseEntity in
            if let response = responseEntity {
                print(response.delete)
                data = [.title("Тут пусто 😟")]
                tableView.reloadData()
            } else {
                print("error makeDeleteRecentlyPlacesForPersonWithIdRequest")
            }
        }
    }

    @objc func refreshRecentlyPlacesAction() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        RecentlyPlacesNetworkManager.makeGetRecentlyPlacesForPersonWithIdRequest(id: userId) { [self] responseEntity in
            if let response = responseEntity {
                data = []

                for place in response.recentlyPlaces {
                    data.append(.place(RecentlyPlaceData(name: place.nameOfPlace, imageUrl: place.photos.first!.photoURL)))
                }

                if data.count == 0 {
                    data.append(.title("Тут пусто 😟"))
                }

                tableView.reloadData()

            } else {
                if data.count == 0 {
                    data.append(.title("Тут пусто 😟"))
                }
                tableView.reloadData()
                print("error")
            }
            refresh.endRefreshing()
        }
    }
}

// MARK: - UITableViewDataSource

extension RecentlyPlacesViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return data.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        switch data[index] {
        case let .place(recentlyPlace):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecentlyPlaceCell.self)) as! RecentlyPlaceCell

            cell.configure(with: RecentlyPlaceData(name: recentlyPlace.name, imageUrl: recentlyPlace.imageUrl))

            return cell
        case let .title(text):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmallTitleCell.self)) as! SmallTitleCell

            cell.configure(with: text)

            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension RecentlyPlacesViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}
