//
//  MapPlacesCollectionView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

class MapPlacesCollectionView: UICollectionView {

    // MARK: - Init
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: frame, collectionViewLayout: layout)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private methods
private extension MapPlacesCollectionView {
    func initialize(){
        backgroundColor = .clear
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        register(MapPlaceCell.self, forCellWithReuseIdentifier: String(describing: MapPlaceCell.self))
    }
}