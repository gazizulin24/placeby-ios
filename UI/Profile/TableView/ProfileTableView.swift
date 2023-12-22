//
//  ProfileTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 20.12.23.
//

import UIKit

final class ProfileTableView: UITableView {
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

// MARK: - Private methods

private extension ProfileTableView {
    func initialization() {
        separatorColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        backgroundColor = .white
        register(UsernameProfileCell.self, forCellReuseIdentifier: String(describing: UsernameProfileCell.self))
        register(ProfileMultiCell.self, forCellReuseIdentifier: String(describing: ProfileMultiCell.self))
        register(SmallLabelCell.self, forCellReuseIdentifier: String(describing: SmallLabelCell.self))
    }
}
