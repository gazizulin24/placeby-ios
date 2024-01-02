//
//  UsernameProfileCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 20.12.23.
//

import UIKit

final class UsernameProfileCell: UITableViewCell {
    func configure(username: String, sex: String) {
        print("username: ", username)
        usernameLabel.text = "Здравствуйте, \(username)!"

        sexLabel.text = genders[sex]
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
        static let infoViewHeight: CGFloat = 130
        static let infoViewWidth: CGFloat = 370
        static let usernameTextFontSize: CGFloat = 20
        static let labelsOffset: CGFloat = 15
    }

    private let genders: [String: String] = ["male": "👨", "unowned": "👽", "female": "👩"]

    // MARK: - Private properties

    private let infoView: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 0.2))

        view.layer.cornerRadius = 15

        return view
    }()

    private lazy var sexLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center

        label.font = .systemFont(ofSize: UIConstants.usernameTextFontSize + 30, weight: .bold)

        label.textColor = .black

        return label
    }()

    private lazy var usernameLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center

        label.font = .systemFont(ofSize: UIConstants.usernameTextFontSize, weight: .bold)

        label.textColor = .black

        return label
    }()
}

// MARK: - Private methods

private extension UsernameProfileCell {
    func initialization() {
        contentView.backgroundColor = .white
        contentView.addSubview(infoView)

        infoView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.top.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(UIConstants.infoViewHeight)
            make.width.equalTo(UIConstants.infoViewWidth)
        }

        infoView.addSubview(sexLabel)

        sexLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(20)
            make.height.equalTo(50)
        }

        infoView.addSubview(usernameLabel)

        usernameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sexLabel.snp.bottom).offset(UIConstants.labelsOffset)
        }
    }
}
