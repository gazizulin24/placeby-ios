//
//  NotificationsViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 21.12.23.
//

import SnapKit
import UIKit

class NotificationsViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private let notifications: [[String]] = [["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"],
                                             ["Супер обнова 21 декабря добавили сообщения",
                                              "https://youtu.be/dQw4w9WgXcQ?si=51FrMIvCk-k5wHf_"],
                                             ["Согласитесь же норм работает тема",
                                              "https://kinogo.io/56909-slovo-pacana-krov-na-asfalte-1-sezon-2023-123.html"]]

    // MARK: - Private properties

    private lazy var tableView: NotificationsPageTableView = {
        let tableView = NotificationsPageTableView()

        tableView.dataSource = self
        return tableView
    }()

    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Уведомления 🔔"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()
}

// MARK: - Private mehtods

private extension NotificationsViewController {
    func initialization() {
        view.backgroundColor = .white

        view.addSubview(tableView)

        configNavigation()

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
        navigationController?.popViewController(animated: true)
        navigationController?.isNavigationBarHidden = true
    }
}

// MARK: - UITableViewDataSource

extension NotificationsViewController: UITableViewDataSource {
    func tableView(_: UITableView, numberOfRowsInSection _: Int) -> Int {
        return notifications.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: NotificationCell.self), for: indexPath) as! NotificationCell

        let notificationData = notifications[indexPath.row]

        cell.config(text: notificationData.first!, url: notificationData.last!)

        return cell
    }
}
