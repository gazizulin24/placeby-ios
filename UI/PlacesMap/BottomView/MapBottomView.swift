//
//  MapBottomView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit
import SnapKit

class MapBottomView: UIView {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private let collectionViewItems:[MapPlacesTypesCollectionViewCellType] = {
        var items = [MapPlacesTypesCollectionViewCellType]()
        
        items.append(.me)
        items.append(.placeType("Все", .all))
        items.append(.placeType("Рядом", .nearby))
        items.append(.placeType("Недавние", .recently))
        items.append(.placeType("Любимые", .favourite))
        
        return items
    }()
    
    private enum UIConstants {
        static let cellHeight:CGFloat = 50
        static let meCellWidth:CGFloat = 50
        static let typeCellWidth:CGFloat = 100
        static let typesCollectionViewHeight:CGFloat = 50
        static let placesViewHeight:CGFloat = 200
        static let viewsOffset:CGFloat = 10
    }
    
    // MARK: - Private properties
    
    lazy private var typesCollectionView:MapPlacesTypesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = MapPlacesTypesCollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.dataSource = self
        view.delegate = self
        
        return view
    }()
    
    private let placesView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        view.layer.borderWidth = 1
        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
}

private extension MapBottomView {
    
    func initialize(){
        
        addSubview(typesCollectionView)
        
        typesCollectionView.snp.makeConstraints { make in
            make.width.equalToSuperview()
            make.top.equalToSuperview()
            make.height.equalTo(UIConstants.typesCollectionViewHeight)
        }
        
        addSubview(placesView)
        
        placesView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(UIConstants.placesViewHeight)
            make.bottom.equalToSuperview().inset(UIConstants.viewsOffset)
            make.width.equalToSuperview().multipliedBy(0.95)
        }
    }
}
// MARK: - UICollectionViewDataSource

extension MapBottomView: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return collectionViewItems.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let index = indexPath.row
        
        switch collectionViewItems[index]{
        case .me:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MapMeCell.self), for: indexPath) as! MapMeCell
            
            cell.configure()
            
            return cell
        case .placeType(let title, let placeType):
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MapPlaceTypeCell.self), for: indexPath) as! MapPlaceTypeCell
            
            cell.configure(title: title, type: placeType)
            
            return cell
        }
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapBottomView: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.row
        
        switch collectionViewItems[index]{
        case .me:
            return CGSize(width: UIConstants.meCellWidth, height: UIConstants.cellHeight)
        case .placeType(_):
            return CGSize(width: UIConstants.typeCellWidth, height: UIConstants.cellHeight)
        
        }
    }
}
