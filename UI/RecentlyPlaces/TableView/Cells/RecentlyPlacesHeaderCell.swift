//
//  RecentlyPlacesHeaderCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 29.12.23.
//

import SnapKit
import UIKit

final class RecentlyPlacesHeaderCell: UITableViewCell {
    // MARK: - Public

    func configure(title: String) {
        headerLabel.text = title
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let labelFontSize: CGFloat = 30
    }

    // MARK: - Private properties

    private let headerLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.textColor = .black
        label.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .bold)
        label.textAlignment = .center
        return label
    }()

    private lazy var deleteRecentlyPlacesButton: UIButton = {
        let button = UIButton()

        button.setImage(UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)

        button.addTarget(self, action: #selector(sendRemoveRecentlyPlacesNotification), for: .touchUpInside)

        return button
    }()
}

// MARK: - Private methods

private extension RecentlyPlacesHeaderCell {
    func initialize() {
        contentView.backgroundColor = .white
        contentView.addSubview(headerLabel)

        headerLabel.snp.makeConstraints { make in
            make.centerX.centerY.top.bottom.equalToSuperview()
            make.height.equalTo(80)
        }

        contentView.addSubview(deleteRecentlyPlacesButton)

        deleteRecentlyPlacesButton.snp.makeConstraints { make in
            make.centerY.trailing.equalToSuperview()
            make.size.equalTo(50)
        }
    }

    @objc func sendRemoveRecentlyPlacesNotification() {
        NotificationCenter.default.post(name: Notification.Name("clearRecentlyPlaces"), object: nil)
    }
}
