//
//  SmallTitleCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import UIKit

final class SmallTitleCell: UITableViewCell {
    // MARK: - Public

    func configure(with title: String) {
        titleLabel.text = title
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

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = ""
        label.font = .systemFont(ofSize: 20)
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()
}

// MARK: - Private methods

private extension SmallTitleCell {
    func initialization() {
        contentView.backgroundColor = .white

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.bottom.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(60)
        }
    }
}
