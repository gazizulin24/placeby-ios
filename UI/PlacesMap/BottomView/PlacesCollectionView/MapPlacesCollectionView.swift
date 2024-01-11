//
//  MapPlacesCollectionView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

final class MapPlacesCollectionView: UICollectionView {
    // MARK: - Init

    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: - Private methods

private extension MapPlacesCollectionView {
    func initialize() {
        backgroundColor = .clear

        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false

        register(MapPlaceCell.self, forCellWithReuseIdentifier: String(describing: MapPlaceCell.self))
    }
}
