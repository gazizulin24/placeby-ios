//
//  GlobalSettingsViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit

class GlobalSettingsViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let feedbackBigLabelHeight: CGFloat = 30
        static let feedbackSmallLabelHeight: CGFloat = 70
        static let labelsTopOffset: CGFloat = 10
        static let sublabelHeight: CGFloat = 20
        static let segmentedControlHeight: CGFloat = 40
        static let textFieldHeight: CGFloat = 50
        static let sendFeedbackButtonHeight: CGFloat = 50
    }

    // MARK: - Private properties

    private let settings: [SettingsCells] = [.nearbyRange]

    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Настройки"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()

    private lazy var tableView: GlobalSettingsTableView = {
        let tableView = GlobalSettingsTableView()

        tableView.dataSource = self
        tableView.delegate = self
        return tableView
    }()
}

// MARK: - Private methods

private extension GlobalSettingsViewController {
    func initialize() {
        view.backgroundColor = .white

        configNavigation()

        view.addSubview(tableView)

        tableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }
    }

    func configNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItems = getLeftBarButtonItems()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.titleView = titleLabelView
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back)))

        return items
    }

    @objc func back() {
        navigationController?.setViewControllers([navigationController!.viewControllers.first!], animated: true)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - UITableViewDataSource

extension GlobalSettingsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return settings.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row

        switch settings[index] {
        case .nearbyRange:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlacesNearbySettingsCell.self), for: indexPath) as! PlacesNearbySettingsCell
            return cell
        }
    }
}

// MARK: - UITableViewDelegate

extension GlobalSettingsViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.3) {
            cell.alpha = 1
        }
    }
}
