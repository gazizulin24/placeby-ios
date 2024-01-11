//
//  PlaceMapCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 2.01.24.
//

import UIKit

final class PlaceMapCell: UITableViewCell {
    // MARK: - Public

    func configure(with place: GetAllPlacesRequestResponseSingleEntity) {
        placeCoordinates = PlaceCoordinates(latitude: place.latitude, longitude: place.longitude)

        let distantion = DistantionCalculator.shared.calculateDistanceFromUser(placeCoordinates)

        distantionLabel.text = "\(distantion.rounded(toDecimalPlaces: 2)) км от Вас"
        if distantion < 10 {
            distantionLabel.backgroundColor = UIColor(cgColor: CGColor(red: 47 / 255, green: 135 / 255, blue: 0, alpha: 0.3))
        } else if distantion <= 50 {
            distantionLabel.backgroundColor = UIColor(cgColor: CGColor(red: 250 / 255, green: 120 / 255, blue: 0, alpha: 0.3))
        } else {
            distantionLabel.backgroundColor = UIColor(cgColor: CGColor(red: 255 / 255, green: 25 / 255, blue: 0, alpha: 0.3))
        }
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)

        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let contentHeight: CGFloat = 50
        static let distantionLabelFontSize: CGFloat = 15
        static let itemsLeadingOffset: CGFloat = 10
        static let itemsTopOffset: CGFloat = 10
    }

    // MARK: - Private properties

    private var placeCoordinates: PlaceCoordinates!

    private lazy var openPlaceOnMapButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Открыть на карте", for: .normal)

        button.tintColor = UIColor(cgColor: CGColor(red: 231 / 255, green: 191 / 255, blue: 39 / 255, alpha: 1))
        button.setTitleColor(.black, for: .normal)
        button.addTarget(self, action: #selector(openPlaceOnMap), for: .touchUpInside)

        return button
    }()

    private let distantionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.distantionLabelFontSize, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 0.5))
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 10

        return label
    }()
}

// MARK: - Private methods

private extension PlaceMapCell {
    func initialize() {
        contentView.backgroundColor = .white

        contentView.addSubview(openPlaceOnMapButton)

        openPlaceOnMapButton.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(UIConstants.itemsTopOffset)
            make.trailing.equalToSuperview().inset(UIConstants.itemsLeadingOffset)
            make.width.equalToSuperview().multipliedBy(0.5)
            make.height.equalTo(UIConstants.contentHeight)
        }

        contentView.addSubview(distantionLabel)

        distantionLabel.snp.makeConstraints { make in
            make.centerY.bottom.equalToSuperview()
            make.top.equalToSuperview().offset(UIConstants.itemsTopOffset)
            make.leading.equalTo(UIConstants.itemsLeadingOffset)
            make.width.equalToSuperview().multipliedBy(0.4)
            make.height.equalTo(UIConstants.contentHeight)
        }
    }

    @objc func openPlaceOnMap() {
        UserDefaults.standard.setValue(placeCoordinates.latitude, forKey: "placeToOpenLatitude")
        UserDefaults.standard.setValue(placeCoordinates.longitude, forKey: "placeToOpenLongitude")
        NotificationCenter.default.post(Notification(name: Notification.Name("openPlaceOnMap")))
    }
}
