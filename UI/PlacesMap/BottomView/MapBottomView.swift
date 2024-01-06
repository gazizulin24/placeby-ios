//
//  MapBottomView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit
import SnapKit

final class MapBottomView: UIView {

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private var places:[GetAllPlacesRequestResponseSingleEntity] = []
    
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
        static let placesFontSize:CGFloat = 15
        static let labelHeight:CGFloat = 25
        static let labelTopOffset:CGFloat = 5
        static let placesCollectionViewHeight:CGFloat = 160
        static let placeCellHeight:CGFloat = 160
        static let placeCellWidth:CGFloat = 200
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
    
    lazy private var placesCollectionView:MapPlacesCollectionView = {
        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .horizontal
        let view = MapPlacesCollectionView(frame: .zero, collectionViewLayout: layout)
        
        view.delegate = self
        view.dataSource = self
        
        return view
    }()
    
    private let placesFoundLabel:UILabel = {
        let label = UILabel()
        
        label.text = "Все: 000"
        label.font = .systemFont(ofSize: UIConstants.placesFontSize, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    private let placesView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
//        view.layer.borderWidth = 1
//        view.layer.borderColor = UIColor.black.cgColor
        
        return view
    }()
}

private extension MapBottomView {
    
    func initialize(){
        
        configNotifications()
        
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
        
        placesView.addSubview(placesFoundLabel)
        placesFoundLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(10)
            make.height.equalTo(UIConstants.labelHeight)
            make.top.equalToSuperview().offset(UIConstants.labelTopOffset)
            make.width.equalToSuperview()
        }
        
        placesView.addSubview(placesCollectionView)
        
        placesCollectionView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(placesFoundLabel.snp.bottom)
            make.height.equalTo(UIConstants.placesCollectionViewHeight)
        }
        
        findAllPlaces()
    }
    
    func configNotifications(){
        NotificationCenter.default.addObserver(self, selector: #selector(changePlaceTypeOnMap(_:)), name: Notification.Name("changePlaceTypeOnMap"), object: nil)
    }
    
    @objc func changePlaceTypeOnMap(_ sender:Notification){
        guard let type = sender.object as? PlacesToFocusType else {return}
        
        switch type{
        case .all:
            findAllPlaces()
        case .nearby:
            findPlacesNearby()
        case .recently:
            findRecentlyPlaces()
        case .favourite:
            findFavouritePlaces()
        }
    }
    func findAllPlaces(){
        PlacesNetworkManager.getAllPlacesRequest { responseEntity in
            if let places = responseEntity{
                self.places = places
                self.placesCollectionView.reloadData()
                self.placesFoundLabel.text = "Нашли всех: \(places.count)"
            }
        }
    }
    
    func findRecentlyPlaces(){
        let userId = UserDefaults.standard.integer(forKey: "userId")
        RecentlyPlacesNetworkManager.makeGetRecentlyPlacesForPersonWithIdRequest(id: userId){ responseEntity in
            if let places = responseEntity?.recentlyPlaces{
                
                self.places = places
                self.placesCollectionView.reloadData()
                self.placesFoundLabel.text = "Нашли недавних: \(places.count)"
            }
        }
    }
    
    
    func findFavouritePlaces(){
        let userId = UserDefaults.standard.integer(forKey: "userId")
        FavouritePlacesNetworkManager.getFavouritePlacesForUser(id: userId){ responseEntity in
            if let places = responseEntity?.favPlaces{
                self.places = places
                self.placesCollectionView.reloadData()
                self.placesFoundLabel.text = "Нашли любимых: \(places.count)"
            }
        }
    }
    
    func findPlacesNearby(){
        PlacesNetworkManager.getAllPlacesRequest { responseEntity in
            if var places = responseEntity{
                places = DistantionCalculator.shared.findPlacesNearby(places: places)
                self.places = places
                self.placesCollectionView.reloadData()
                self.placesFoundLabel.text = "Нашли рядом: \(places.count)"
            }
        }
    }
}
// MARK: - UICollectionViewDataSource

extension MapBottomView: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection _: Int) -> Int {
        if collectionView == typesCollectionView{
            return collectionViewItems.count
        } else if collectionView == placesCollectionView {
            return places.count
        }
        return 0
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        
        let index = indexPath.row
        if collectionView == typesCollectionView{
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
        } else if collectionView == placesCollectionView{
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: String(describing: MapPlaceCell.self), for: indexPath) as! MapPlaceCell
            
            cell.configure(with: places[index])
            
            return cell
        }
        
        return UICollectionViewCell()
    }
}

// MARK: - UICollectionViewDelegateFlowLayout

extension MapBottomView: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        
        if collectionView == placesCollectionView{
            cell.alpha = 0.0
            cell.transform = CGAffineTransform(scaleX: 0.8, y: 0.8)
            
            UIView.animate(withDuration: 0.3) {
                cell.alpha = 1.0
                cell.transform = CGAffineTransform.identity
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, layout _: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let index = indexPath.row
        
        if collectionView == typesCollectionView{
            
            switch collectionViewItems[index]{
            case .me:
                return CGSize(width: UIConstants.meCellWidth, height: UIConstants.cellHeight)
            case .placeType(_, _):
                return CGSize(width: UIConstants.typeCellWidth, height: UIConstants.cellHeight)
            }
        } else if collectionView == placesCollectionView{
            return CGSize(width: UIConstants.placeCellWidth, height: UIConstants.placeCellHeight)
        }
        
        return CGSize.zero
    }
}
