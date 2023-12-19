//
//  TitleCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 14.12.23.
//

import UIKit

final class TitleCell: UITableViewCell {
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

        label.text = "Все места"
        label.font = .systemFont(ofSize: 40, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label
    }()
}

// MARK: - Private methods

private extension TitleCell {
    func initialization() {
        contentView.backgroundColor = .white

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.width.bottom.top.equalToSuperview()
            make.height.equalTo(60)
        }
    }
}
