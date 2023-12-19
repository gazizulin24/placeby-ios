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
    func configure(with place: Place) {
        print(place)
        self.place = place

        placeImageView.image = UIImage(named: place.images.first!)
        placeLabel.text = place.name
        placeDescriptionLabel.text = place.description
        distantionLabel.text = "\(place.distantion) от Вас"

        focusOnPlace(coordinates: place.coordinates)
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

    // MARK: - Private properties

    private var place = Place(name: "", description: "", distantion: "", images: [], coordinates: PlaceCoordinates(latitude: 0, longitude: 0))

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
            make.centerX.centerY.size.equalToSuperview()
        }

        return view
    }()

    private let placeImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        return imageView
    }()

    private let placeLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.placeLabelFontSize, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()

    private let placeDescriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.placeLabelFontSize)
        label.textColor = .darkGray
        label.textAlignment = .center
        label.numberOfLines = 3

        return label
    }()

    private let distantionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 15)
        label.textColor = .black
        label.textAlignment = .center
        label.numberOfLines = 1

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

        navigationItem.titleView = placeLabel

        view.addSubview(placeImageView)

        placeImageView.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(view.snp.topMargin)
            make.height.equalTo(UIConstants.imageHeight)
        }

        view.addSubview(placeDescriptionLabel)

        placeDescriptionLabel.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(placeImageView.snp.bottom).offset(UIConstants.imageToLabelOffset)
        }

        placeMapView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(tapToPlaceMapView)))
        view.addSubview(placeMapView)

        placeMapView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(UIConstants.placeMapViewWidthMultiplier)
            make.height.equalTo(UIConstants.placeMapViewHeight)
            make.top.equalTo(placeDescriptionLabel.snp.bottom).offset(UIConstants.labelToMapOffset)
        }

        view.addSubview(distantionLabel)

        distantionLabel.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(placeMapView.snp.bottom).offset(UIConstants.imageToLabelOffset)
        }
    }

    func getRightBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "square.and.arrow.up"), style: .plain, target: self, action: #selector(shareButtonPressed)))

        return items
    }

    @objc func shareButtonPressed() {
        let ac = UIActivityViewController(activityItems: [place.name], applicationActivities: nil)

        present(ac, animated: true)
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(backButtonPressed)))

        return items
    }

    @objc func backButtonPressed() {
        navigationController?.popViewController(animated: true)
        if navigationController?.viewControllers.count == 1 {
            navigationController?.navigationBar.isHidden = true
        }
    }

    @objc func tapToPlaceMapView() {
        UserDefaults.standard.set(Place.basicPlaces.firstIndex(of: place), forKey: "placeIndex")
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
}
