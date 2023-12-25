//
//  PlaceTypesCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 25.12.23.
//


import UIKit
import SnapKit

class PlaceTypesCell: UITableViewCell {
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
        
    }
    
    // MARK: - Private constants
    private enum UIConstants{
        static let collectionViewHeight:CGFloat = 70
        static let cellWidth:CGFloat = 130
        static let cellHeight:CGFloat = 50
    }
    
    // MARK: - Private properties
    lazy private var collectionView:UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(PlaceTypeCell.self, forCellWithReuseIdentifier: String(describing: PlaceTypeCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        
        return collectionView
    }()
    
    private var items:[String] = ["Все", "Охота", "Рыбалка", "Новые", "Активный отдых"]
    
    
    
}

// MARK: - Private methods
private extension PlaceTypesCell{
    func initialize(){
        contentView.backgroundColor = .white
        
        
        collectionView.showsHorizontalScrollIndicator = false
        contentView.addSubview(collectionView)
        collectionView.snp.makeConstraints { make in
            make.edges.equalToSuperview()
            make.height.equalTo(UIConstants.collectionViewHeight)
        }
    }
}


// MARK: - UICollectionViewDataSource
extension PlaceTypesCell: UICollectionViewDataSource{
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: PlaceTypeCell.self), for: indexPath) as! PlaceTypeCell
        cell.configure(with: items[indexPath.item])
        return cell
    }
    
}

// MARK: - UICollectionViewDelegateFlowLayout
extension PlaceTypesCell: UICollectionViewDelegateFlowLayout{
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: UIConstants.cellWidth, height: UIConstants.cellHeight)
    }
}
