//
//  SimilarPlacesCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 3.01.24.
//

import UIKit

final class SimilarPlacesCell: UITableViewCell {
    
    // MARK: - Public
    
    func configure(with place: GetAllPlacesRequestResponseSingleEntity) {
        let findSimilarBy = place.types.last?.name
        
        PlacesNetworkManager.getAllPlacesByTypeRequest(findSimilarBy ?? "other") { [self] responseEntity in
            if let places = responseEntity {
                similarPlaces = places
                collectionView.reloadData()
            } else {
                print("error getAllPlacesByTypeRequest")
            }
        }
    }

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
        static let similarLabelFontSize:CGFloat = 20
        static let similarOffset:CGFloat = 10
        static let similarLabelTopOffset:CGFloat = 20
        static let cellWidth:CGFloat = 250
        static let cellHeight:CGFloat = 180
        static let collectionViewHeight:CGFloat = 180
        static let similarPlacesLabelHeight:CGFloat = 25
    }
    
    // MARK: - Private properties
    
    var similarPlaces:GetAllPlacesRequestResponseEntity = []
    
    private let similarPlacesLabel:UILabel = {
        let label = UILabel()
        
        label.text = "Похожие места"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIConstants.similarLabelFontSize, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    
    private lazy var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        collectionView.register(SimilarPlaceCell.self, forCellWithReuseIdentifier: String(describing: SimilarPlaceCell.self))
        collectionView.dataSource = self
        collectionView.delegate = self
        collectionView.backgroundColor = .white
        collectionView.showsHorizontalScrollIndicator = false
        collectionView.showsVerticalScrollIndicator = false

        return collectionView
    }()
    
    lazy private var moreButton:UIButton = {
        let button = UIButton()
        
        button.addTarget(self, action: #selector(moreSimilar), for: .touchUpInside)
        button.setImage(UIImage(systemName: "ellipsis")?.withTintColor(.black, renderingMode: .alwaysOriginal), for: .normal)
        
        
        return button
        
    }()
    
}

// MARK: - Private methods
private extension SimilarPlacesCell {
    func initialize(){
        contentView.backgroundColor = .white
        
        contentView.addSubview(similarPlacesLabel)
        
        similarPlacesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIConstants.similarOffset)
            make.top.equalToSuperview().offset(UIConstants.similarLabelTopOffset)
            make.height.equalTo(UIConstants.similarPlacesLabelHeight)
        }
        
        contentView.addSubview(moreButton)
        
        moreButton.snp.makeConstraints{ make in
            make.trailing.equalToSuperview().inset(UIConstants.similarOffset*2)
            make.top.equalToSuperview().offset(UIConstants.similarLabelTopOffset)
            make.size.equalTo(UIConstants.similarPlacesLabelHeight)
        }
        
        contentView.addSubview(collectionView)
        
        collectionView.snp.makeConstraints { make in
            make.bottom.centerX.equalToSuperview()
            make.width.equalToSuperview()
            make.top.equalTo(similarPlacesLabel.snp.bottom).offset(UIConstants.similarOffset)
            make.height.equalTo(UIConstants.collectionViewHeight)
        }
    }
    
    @objc func tapToPlace(_ sender: UITapGestureRecognizer){
        
        guard let cell = sender.view as? SimilarPlaceCell else { return }
        UserDefaults.standard.setValue(cell.placeId, forKey: "placeId")
        print("tap")
        NotificationCenter.default.post(Notification(name: Notification.Name("findPlace")))
    }
    
    @objc func moreSimilar(){
        print("moreSimilar")
        if let tableView = superview as? UITableView,
           let viewController = tableView.delegate as? PlaceViewController {
            let vc = SimilarPlacesViewController()
            
            vc.configure(with: similarPlaces)
            viewController.navigationController?.pushViewController(vc, animated: true)
        }
    }
}


// MARK: - UICollectionViewDataSource

extension SimilarPlacesCell: UICollectionViewDataSource {
    func collectionView(_: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        return similarPlaces.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: SimilarPlaceCell.self), for: indexPath) as! SimilarPlaceCell
        
        cell.configure(with: similarPlaces[indexPath.item])
        
        cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToPlace(_:))))
        
        return cell
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension SimilarPlacesCell: UICollectionViewDelegateFlowLayout {
    func collectionView(_: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt _: IndexPath) -> CGSize {
        return CGSize(width: UIConstants.cellWidth, height: UIConstants.cellHeight)
    }
}
