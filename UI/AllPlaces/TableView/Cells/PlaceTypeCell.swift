//
//  PlaceTypeCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 25.12.23.
//

import UIKit

final class PlaceTypeCell: UICollectionViewCell {
    // MARK: - Public

    func configure(with data: PlaceType) {
        placeTypeButton.setTitle(data.title, for: .normal)
        placeTypeButton.sizeToFit()
        placeType = data
        placeTypeButton.addTarget(self, action: #selector(selectPlaceType), for: .touchUpInside)
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private var placeType: PlaceType!

    private let placeTypeButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Lorem Ipsum", for: .normal)
        button.setTitleColor(.black, for: .normal)
        button.setTitleColor(.darkGray, for: .highlighted)

        button.tintColor = UIColor(cgColor: CGColor(red: 231 / 255, green: 191 / 255, blue: 39 / 255, alpha: 1))
        button.titleLabel?.textAlignment = .center
        button.titleLabel?.adjustsFontSizeToFitWidth = true
        return button
    }()
}

// MARK: - Private Methods

private extension PlaceTypeCell {
    @objc func selectPlaceType() {
        PlaceType.savePlaceTypeToUserDefaults(placeType: placeType)
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
        print(placeType.dbTitle)
    }

    func initialize() {
        contentView.addSubview(placeTypeButton)
        placeTypeButton.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
}
