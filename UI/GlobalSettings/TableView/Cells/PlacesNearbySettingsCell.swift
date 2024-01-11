//
//  PlacesNearbySettingsCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

final class PlacesNearbySettingsCell: UITableViewCell {
    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Места рядом искать в радиусе \(UserDefaults.standard.integer(forKey: "placesNearbyRange"))км"

        label.font = .systemFont(ofSize: 15, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true

        return label
    }()

    private lazy var rangeSlider: UISlider = {
        let slider = UISlider()

        slider.maximumValue = 25
        slider.minimumValue = 1

        slider.value = Float(UserDefaults.standard.integer(forKey: "placesNearbyRange"))
        slider.addTarget(self, action: #selector(sliderValueChanged), for: .valueChanged)
        slider.minimumTrackTintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))

        return slider
    }()
}

// MARK: - Private methods

private extension PlacesNearbySettingsCell {
    func initialize() {
        backgroundColor = .white

        contentView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerY.bottom.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.width.equalToSuperview().multipliedBy(0.65)
            make.height.equalTo(50)
        }

        contentView.addSubview(rangeSlider)

        rangeSlider.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.width.equalToSuperview().multipliedBy(0.25)
        }
    }

    @objc func sliderValueChanged() {
        let range = Int(rangeSlider.value)

        titleLabel.text = "Места рядом искать в радиусе \(range)км"

        UserDefaults.standard.setValue(range, forKey: "placesNearbyRange")
    }
}
