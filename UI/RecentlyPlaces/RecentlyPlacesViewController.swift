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

    // MARK: - Private constants

    private enum TextConstants {
        static let headerCellText: String = "Недавние"
        static let noPlacesText: String = "Тут пусто 😟"
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

        data.append(.header(TextConstants.headerCellText))

        return data
    }()

    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = TextConstants.headerCellText
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
        
        navigationController?.isNavigationBarHidden = true
        //configNavigation()
        
        setupNotifications()

        view.addSubview(tableView)
        tableView.addSubview(refresh)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }

        refreshRecentlyPlacesAction()
    }
    
    func setupNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(clearRecentlyPlaces), name: Notification.Name("clearRecentlyPlaces"), object: nil)
    }

    func configNavigation() {
        navigationItem.titleView = titleLabelView
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
                data = [.header(TextConstants.headerCellText), .title(TextConstants.noPlacesText)]
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
                data = [.header(TextConstants.headerCellText)]

                for place in response.recentlyPlaces {
                    data.append(.place(RecentlyPlaceData(name: place.nameOfPlace, imageUrl: place.photos.first!.photoURL, id:place.id)))
                }

                if data.count == 1 {
                    data.append(.title(TextConstants.noPlacesText))
                }

                tableView.reloadData()

            } else {
                data = []
                data.append(.header(TextConstants.headerCellText))
                data.append(.title(TextConstants.noPlacesText))
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

            cell.configure(with: RecentlyPlaceData(name: recentlyPlace.name, imageUrl: recentlyPlace.imageUrl, id:recentlyPlace.id))

            return cell
        case let .title(text):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmallTitleCell.self)) as! SmallTitleCell

            cell.configure(with: text)

            return cell
        case let .header(title):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: RecentlyPlacesHeaderCell.self)) as! RecentlyPlacesHeaderCell

            cell.configure(title: title)

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
