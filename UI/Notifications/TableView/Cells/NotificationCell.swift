//
//  NotificationCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 21.12.23.
//

import SnapKit
import UIKit

class NotificationCell: UITableViewCell {
    func config(text: String, url: String) {
        notificaitonLabel.text = text
        notificationUrl = url
    }

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialization()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let notificationHeight: CGFloat = 70
        static let notificationWidth: CGFloat = 270
        static let notificationLabelFontSize: CGFloat = 14
        static let deleteNotificationButtonSize: CGFloat = 50
    }

    // MARK: - Private properties

    private var notificationUrl = ""

    private let notificationView: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 0.7))
        view.layer.cornerRadius = 15

        return view
    }()

    private lazy var notificationInfoButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "info.circle")?.withTintColor(UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1)), renderingMode: .alwaysOriginal), for: .normal)

        button.addTarget(self, action: #selector(buttonUrl), for: .touchUpInside)
        return button
    }()

    private let notificaitonLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.notificationLabelFontSize)

        label.textAlignment = .left

        label.numberOfLines = 2

        label.textColor = .black

        return label
    }()

    private lazy var deleteNotificationButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "xmark.circle.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)

        button.imageView?.contentMode = .scaleAspectFill

        button.addTarget(self, action: #selector(deleteNotification), for: .touchUpInside)

        return button
    }()
}

// MARK: - Private methods

private extension NotificationCell {
    func initialization() {
        contentView.backgroundColor = .white
        contentView.addSubview(notificationView)

        notificationView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(UIConstants.notificationHeight)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.top.equalToSuperview().offset(UIConstants.deleteNotificationButtonSize / 2)
            make.bottom.equalToSuperview()
        }

        notificationView.addSubview(notificationInfoButton)

        notificationInfoButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.size.equalTo(30)
            make.leading.equalToSuperview().offset(10)
        }

        notificationView.addSubview(notificaitonLabel)

        notificaitonLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalTo(notificationInfoButton.snp.trailing).offset(10)
            make.height.equalToSuperview().multipliedBy(0.9)
            make.width.equalToSuperview().multipliedBy(0.8)
        }

//        notificationView.addSubview(deleteNotificationButton)
//
//        deleteNotificationButton.snp.makeConstraints { make in
//            make.centerX.equalTo(notificationView.snp.trailing)
//            make.centerY.equalTo(notificationView.snp.top)
//            make.size.equalTo(UIConstants.deleteNotificationButtonSize)
//        }
    }

    @objc func deleteNotification() {
        print("delete notification")
    }

    @objc func buttonUrl() {
        if let url = URL(string: notificationUrl) {
            UIApplication.shared.open(url)
        }
    }
}
