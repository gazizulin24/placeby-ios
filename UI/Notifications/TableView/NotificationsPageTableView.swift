//
//  NotificationsPageTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 21.12.23.
//

import UIKit

final class NotificationsPageTableView: UITableView {
    // MARK: - Initialization

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)

        initialization()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

private extension NotificationsPageTableView {
    func initialization() {
        backgroundColor = .white

        separatorColor = .clear

        register(NotificationCell.self, forCellReuseIdentifier: String(describing: NotificationCell.self))
    }
}
