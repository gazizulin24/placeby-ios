//
//  PlaceViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import MapKit
import SnapKit
import UIKit
import YandexMapsMobile

final class PlaceViewController: UIViewController {
    
    // MARK: - Public
    
    func configureWithId(_ id:Int){
        PlacesNetworkManager.getPlacebyIdRequest(id) {[self] responseEntity in
            if let place = responseEntity {
                placeDataLoaded()
                self.place = place
                placeLabel.text = place.nameOfPlace
                print(placeLabel.text!)
                navigationItem.titleView = placeLabel
                
                checkIsPlaceIsFav(place.id)
                
                data = []
                
                
                
                data.append(.images(place.photos))
                data.append(.description(place))
                data.append(.map(place))
                data.append(.schedule(place))
                data.append(.categories(place))
                data.append(.similar(place))
                data.append(.report(place.nameOfPlace))
                data.append(.smallLabel(""))
                

                
                placeTableView.reloadData()
                
            } else{
                print("error getPlacebyIdRequest")
            }
        }
    }
    


    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let imageHeight: CGFloat = 250
        static let placeLabelFontSize: CGFloat = 20
        static let imageToLabelOffset: CGFloat = 15
        static let placeMapViewWidthMultiplier: CGFloat = 0.9
        static let placeMapViewHeight: CGFloat = 200
        static let labelToMapOffset: CGFloat = 10
    }

    private enum ImageConstants {
        static let unlikedImage: UIImage? = UIImage(systemName: "heart")?.withTintColor(.black, renderingMode: .alwaysOriginal)
        static let likedImage: UIImage? = UIImage(systemName: "heart.fill")?.withTintColor(.red, renderingMode: .alwaysOriginal)
    }

    // MARK: - Private properties
    
    private var data:[PlaceTableViewCellType] = []

    private var isLiked = false

    private var place:GetAllPlacesRequestResponseSingleEntity!
    
    lazy private var placeTableView:PlaceTableView = {
        let tableView = PlaceTableView()
        
        tableView.backgroundColor = .white
        
        tableView.dataSource = self
        tableView.delegate = self
        
        return tableView
    }()
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.startAnimating()

        indicator.color = .black

        return indicator
    }()

    private let placeLabel:UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIConstants.placeLabelFontSize, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()

}

private extension PlaceViewController {
    func initialization() {
        navigationController?.navigationBar.isHidden = false
        view.backgroundColor = .white

        navigationController?.navigationBar.tintColor = .black

        navigationItem.hidesBackButton = true

        navigationItem.leftBarButtonItems = getLeftBarButtonItems()
        navigationItem.rightBarButtonItems = getRightBarButtonItems()

        navigationItem.titleView = indicator

        view.addSubview(indicator)

        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        
        placeTableView.isHidden = true
        
        view.addSubview(placeTableView)
        
        placeTableView.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.width.bottom.equalToSuperview()
        }
        
    }
    
    func checkIsPlaceIsFav(_ placeId:Int){
        let userId = UserDefaults.standard.integer(forKey: "userId")
        PlacesNetworkManager.isPlaceIsFavouriteForUser(userId: userId, placeId: placeId) { [self] responseEntity in
            if let response = responseEntity {
                setLikedButton(response.isFavourite)
            } else{
                print("error isPlaceIsFavouriteForUser")
                setLikedButton(false)
            }
            
        }
    }
    
    func placeDataLoaded(){
        indicator.stopAnimating()
        indicator.isHidden = true
        placeTableView.isHidden = false
    }

    func getRightBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: ImageConstants.unlikedImage, style: .plain, target: self, action: #selector(likeButtonTapped(_:))))

        items.append(UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonPressed)))

        return items
    }

    @objc func shareButtonPressed() {
        
        let text = "Зацени \(place.nameOfPlace) на placeby! \(place.photos.first!.photoURL)"
        
        let ac = UIActivityViewController(activityItems: [text], applicationActivities: nil)
        
        present(ac, animated: true)
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed)))

        return items
    }
    
    func setLikedButton(_ isActive: Bool) {
        isLiked = isActive
        if isLiked {
            navigationItem.rightBarButtonItems?.first?.image = ImageConstants.likedImage
        } else {
            navigationItem.rightBarButtonItems?.first?.image = ImageConstants.unlikedImage
        }
    }

    @objc func likeButtonTapped(_ sender: UIBarButtonItem) {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        if isLiked {
            FavouritePlacesNetworkManager.deleteFavouritePlaceForUser(placeId: place.id, personId: userId)
            sender.image = ImageConstants.unlikedImage
            isLiked = false
        } else {
            FavouritePlacesNetworkManager.makePlaceFavouriteForPerson(placeId: place.id, personId: userId)
            sender.image = ImageConstants.likedImage
            isLiked = true
            
            let alert = UIAlertController(title: "Место добавлено в любимые!", message: "Хотите перейти ко всем любимым местам?", preferredStyle: .alert)

            alert.addAction(UIAlertAction(title: "Перейти", style: .default, handler: { _ in
                NotificationCenter.default.post(name: Notification.Name("openLikedPlaces"), object: nil)
            }))
            alert.addAction(UIAlertAction(title: "Закрыть", style: .cancel))
            present(alert, animated: true, completion: nil)
        }
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        if navigationController?.viewControllers.count == 1 {
            navigationController?.navigationBar.isHidden = true
        }
    }
    
    @objc func openSchedule(){
        NotificationCenter.default.post(Notification(name: Notification.Name("openSchedule")))
    }

}

// MARK: - UITableViewDataSource
extension PlaceViewController:UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return data.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let index = indexPath.row
        
        switch data[index] {
        case .images(let images):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ImagesCell.self)) as! ImagesCell
            cell.configure(images: images)
            
            return cell
        case .description(let data):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceDescriptionCell.self), for: indexPath) as! PlaceDescriptionCell
            
            cell.configure(with:data)
            
            return cell
            
        case .categories(let place):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceCategoriesCell.self), for: indexPath) as! PlaceCategoriesCell
            
            cell.configure(with: place)
            
            return cell
        case .map(let place):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceMapCell.self), for: indexPath) as! PlaceMapCell
            
            cell.configure(with: place)
            
            return cell
        case .similar(let place):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SimilarPlacesCell.self), for: indexPath) as! SimilarPlacesCell
            
            cell.configure(with: place)
            
            return cell
        case .report(let placeName):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: ReportPlaceCell.self), for: indexPath) as! ReportPlaceCell
            
            cell.configure(with: placeName)
            
            return cell
        case .smallLabel(let text):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SmallLabelCell.self), for: indexPath) as! SmallLabelCell
            
            cell.configure(with: text)
            
            return cell
        case .schedule(let place):
            let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: PlaceScheduleCell.self), for: indexPath) as! PlaceScheduleCell
            
            cell.configure(with: place)
            
            
            cell.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openSchedule)))
            return cell
        }
    }
}


// MARK: - UITableViewDelegate

extension PlaceViewController: UITableViewDelegate {
    func tableView(_: UITableView, willDisplay cell: UITableViewCell, forRowAt _: IndexPath) {
        cell.alpha = 0

        UIView.animate(withDuration: 0.3) {
                cell.alpha = 1
            }
        
    }
}
