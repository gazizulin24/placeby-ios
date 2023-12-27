//
//  AllPlacesTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import UIKit

final class AllPlacesTableView: UITableView {
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

private extension AllPlacesTableView {
    func initialization() {
        separatorColor = .clear
        backgroundColor = .white
        register(PlaceCell.self, forCellReuseIdentifier: String(describing: PlaceCell.self))
        register(TitleCell.self, forCellReuseIdentifier: String(describing: TitleCell.self))
        register(PlaceTypesCell.self, forCellReuseIdentifier: String(describing: PlaceTypesCell.self))
        register(LoadingCell.self, forCellReuseIdentifier: String(describing: LoadingCell.self))
        register(RecomendationsCell.self, forCellReuseIdentifier: String(describing: RecomendationsCell.self))
    }
}
