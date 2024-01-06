//
//  MapPlacesTypesCollectionView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

final class MapPlacesTypesCollectionView: UICollectionView {

    
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
private extension MapPlacesTypesCollectionView {
    func initialize(){
        backgroundColor = .clear
        
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        register(MapMeCell.self, forCellWithReuseIdentifier: String(describing: MapMeCell.self))
        register(MapPlaceTypeCell.self, forCellWithReuseIdentifier: String(describing: MapPlaceTypeCell.self))
    }
}
