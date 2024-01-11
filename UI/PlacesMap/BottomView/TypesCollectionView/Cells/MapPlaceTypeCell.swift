//
//  MapPlaceTypeCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

final class MapPlaceTypeCell: UICollectionViewCell {
    func configure(title: String, type: PlacesToFocusType) {
        typeLabel.text = title
        self.type = type
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

    private var type: PlacesToFocusType!

    private let typeLabel: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.font = .systemFont(ofSize: 18, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))

        return label
    }()
}

// MARK: - Private methods

private extension MapPlaceTypeCell {
    func initialize() {
        backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        layer.cornerRadius = 20
        clipsToBounds = true
//        layer.borderColor = CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1)
//        layer.borderWidth = 2
        addSubview(typeLabel)

        typeLabel.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.8)
            make.center.equalToSuperview()
        }

        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(configPlacesType)))
    }

    @objc func configPlacesType() {
        NotificationCenter.default.post(name: Notification.Name("changePlaceTypeOnMap"), object: type)
    }
}
