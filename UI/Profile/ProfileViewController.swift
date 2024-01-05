//
//  ProfileViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 14.12.23.
//

import SnapKit
import UIKit

final class ProfileViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        navigationController?.isNavigationBarHidden = true

        initialization()
        makeRequest()
    }

    // MARK: - Private constatnts

    private enum UIConstants {
        static let cellWidth: CGFloat = 370
        static let cellHeight: CGFloat = 100
    }

    private lazy var tableViewCells: [ProfileTableViewCellType] = [
        .username,
        .multiCell([.multiCellSubcell("Любимые", "heart.fill", "openLikedPlaces"),
                    .multiCellSubcell("Уведомления", "bell.fill", "openNotificationsPage")]),
        .multiCell([.multiCellSubcell("Настройки профиля", "person.fill", "openProfileSettingsPage"),
                    .multiCellSubcell("Общие настройки", "gearshape.fill", "openSettingsPage")]),
        .multiCell([.multiCellSubcell("Обратная связь", "repeat.circle.fill", "openFeedback"),
                    .multiCellSubcell("Выйти", "door.left.hand.closed", "logout")]),
        .smallLabel("placeby.com 2024. Все права защищены."),
    ]

    // MARK: - Prviate properties

    private var user = User(phoneNum: "", name: "", birthday: "", sex: "")

    private lazy var mainTableView: ProfileTableView = {
        let tableView = ProfileTableView()

        tableView.isHidden = true

        tableView.backgroundColor = .white
        tableView.dataSource = self
        return tableView
    }()

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.startAnimating()

        indicator.color = .black

        return indicator
    }()
}

// MARK: - Private methods

private extension ProfileViewController {
    func initialization() {
        configureNotifications()

        view.backgroundColor = .white

        view.addSubview(indicator)

        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(mainTableView)

        mainTableView.snp.makeConstraints { make in
            make.center.width.bottom.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
        }
    }

    func makeRequest() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        UserNetworkManager.makeGetPersonRequest(id: userId) { responseEntity in
            if let response = responseEntity {
                self.user = User(phoneNum: response.phoneNumber,
                                 name: response.name,
                                 birthday: response.dateOfBirth,
                                 sex: response.gender)
                UserDefaults.standard.setValue(response.name, forKey: "username")
                UserDefaults.standard.setValue(response.gender, forKey: "userGender")
                self.endLoading()
            } else {
                print("ошибка makeGetPersonRequest")
//                self.user = User(phoneNum: "333496508", name: "Егор", birthday: "2007-09-12", sex: "male")
//                self.endLoading()
            }
        }
    }

    func configureNotifications() {}

    func endLoading() {
        indicator.isHidden = true
        mainTableView.isHidden = false

        fillTableView()
    }

    func fillTableView() {
        mainTableView.reloadData()
    }

    @objc func logoutButtonPressed() {
        NotificationCenter.default.post(Notification(name: Notification.Name("logout")))
    }
}

extension ProfileViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return tableViewCells.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cellType = tableViewCells[indexPath.row]

        switch cellType {
        case .username:
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: UsernameProfileCell.self)) as! UsernameProfileCell
            cell.configure(username: user.name, sex: user.sex)

            return cell
        case let .multiCell(cells):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ProfileMultiCell.self)) as! ProfileMultiCell

            cell.configure(with: cells)

            return cell
        case let .smallLabel(text):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmallLabelCell.self)) as! SmallLabelCell

            cell.configure(with: text)

            return cell
        default:
            print(cellType)
        }
        return UITableViewCell()
    }
}
