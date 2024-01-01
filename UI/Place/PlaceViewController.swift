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
                
                data = []
                
                data.append(.images(place.photos))
                
                placeTableView.reloadData()
                print(data.count)
                
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
    

    private let placeMap: YMKMapView = {
        let mapView = YMKMapView()

        mapView.isUserInteractionEnabled = false

        mapView.layer.cornerRadius = 15
        mapView.clipsToBounds = true

        return mapView
    }()

    private lazy var placeMapView: UIView = {
        let view = UIView()

        view.addSubview(placeMap)

        placeMap.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.width.bottom.equalToSuperview()
        }

        return view
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
        let ac = UIActivityViewController(activityItems: [place.nameOfPlace], applicationActivities: nil)
        
        present(ac, animated: true)
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed)))

        return items
    }

    @objc func likeButtonTapped(_ sender: UIBarButtonItem) {
        isLiked.toggle()
        if isLiked {
            sender.image = ImageConstants.likedImage
        } else {
            sender.image = ImageConstants.unlikedImage
        }
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        if navigationController?.viewControllers.count == 1 {
            navigationController?.navigationBar.isHidden = true
        }
    }

    @objc func tapToPlaceMapView() {
        UserDefaults.standard.setValue(place.latitude, forKey: "placeToOpenLatitude")
        UserDefaults.standard.setValue(place.longitude, forKey: "placeToOpenLongitude")
        NotificationCenter.default.post(Notification(name: Notification.Name("openPlaceOnMap")))
    }

    func focusOnPlace(coordinates coord: PlaceCoordinates) {
        placeMap.mapWindow.map.move(
            with: YMKCameraPosition(
                target: YMKPoint(latitude: coord.latitude, longitude: coord.longitude),
                zoom: 17,
                azimuth: 0,
                tilt: 0
            ),
            animation: YMKAnimation(type: YMKAnimationType.smooth, duration: 1),
            cameraCallback: nil
        )
    }

    func setImageByUrl(url: String) {
        PhotosNetworkManager.loadPhoto(url: url) { [self] responseData in
            if let data = responseData {
                print(data)
            } else {
                print("не удалось загрузить фото")
            }
        }
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
