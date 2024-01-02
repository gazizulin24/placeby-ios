//
//  RecentlyPlacesTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import UIKit

final class RecentlyPlacesTableView: UITableView {
    // MARK: - Init

    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension RecentlyPlacesTableView {
    func initialize() {
        backgroundColor = .white
        separatorColor = .clear

        register(RecentlyPlaceCell.self, forCellReuseIdentifier: String(describing: RecentlyPlaceCell.self))
        register(SmallTitleCell.self, forCellReuseIdentifier: String(describing: SmallTitleCell.self))
        register(RecentlyPlacesHeaderCell.self, forCellReuseIdentifier: String(describing: RecentlyPlacesHeaderCell.self))
    }
}
