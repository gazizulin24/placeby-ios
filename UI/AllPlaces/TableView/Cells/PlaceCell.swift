//
//  PlaceCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import SnapKit
import UIKit

final class PlaceCell: UITableViewCell {
    // MARK: - Public methods

    func configure(with place:GetAllPlacesRequestResponseSingleEntity) {
        setImageByUrl(url: place.photos.first!.photoURL)

        titleLabel.text = place.nameOfPlace
        descriptionLabel.text = place.description
        placeId = place.id
        
        let distantion = DistantionCalculator.shared.calculateDistanceFromUser(PlaceCoordinates(latitude: place.latitude, longitude: place.longitude))
        print(distantion)
        distantionLabel.text = "\(distantion.rounded(toDecimalPlaces: 1)) км"
        
    }

    // MARK: - Initialization

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialization()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Public properties

    var placeId = 0
    

    // MARK: - Private constant

    private enum UIConstants {
        static let cellWidth: CGFloat = 350
        static let imageHeight: CGFloat = 250
        static let contentCardViewHeight: CGFloat = 320
        static let titleLabelFontSize: CGFloat = 30
        static let cellHeight: CGFloat = 300
        static let titleLabelHeight: CGFloat = 30
        static let locationLabelFontSize: CGFloat = 10
        static let contentCardViewInsetOffset: CGFloat = 10
        static let contentCardViewWidthMultiplier: CGFloat = 0.95
        static let contentCardViewCornerRadius: CGFloat = 10
        static let titleLabelLeadingOffset: CGFloat = 10
        static let titleLabelTopOffset:CGFloat = 5
        static let descriptionLabelTopOffset:CGFloat = 3
        static let distantionLabelTopOffset:CGFloat = 5
        static let distantionLabelHeight:CGFloat = 60
    }

    // MARK: - Private properties

    private let contentCardView: UIView = {
        let view = UIView()

        return view
    }()

    private let placeImage: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.backgroundColor = .lightGray

        imageView.layer.cornerRadius = UIConstants.contentCardViewCornerRadius
        return imageView
    }()

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize, weight: .bold)
        label.textColor = .black
        label.textAlignment = .left

        return label
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize-10, weight: .bold)
        label.textColor = .lightGray
        label.textAlignment = .left

        return label
    }()

    private let distantionLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize-10, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center
        label.backgroundColor = UIColor(cgColor: CGColor(red: 251/255, green: 211/255, blue: 59/255, alpha: 0.5))
        label.adjustsFontSizeToFitWidth = true
        label.clipsToBounds = true
        label.layer.cornerRadius = 10

        return label
    }()
}

// MARK: - Private methods

private extension PlaceCell {
    func initialization() {
        backgroundColor = .white

        selectionStyle = .none

        contentView.addSubview(contentCardView)

        contentCardView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().offset(UIConstants.contentCardViewInsetOffset)
            make.width.equalToSuperview().multipliedBy(UIConstants.contentCardViewWidthMultiplier)
            make.height.equalTo(UIConstants.contentCardViewHeight)
            make.bottom.equalToSuperview().inset(UIConstants.contentCardViewInsetOffset)
        }

        contentCardView.addSubview(placeImage)

        placeImage.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview()
            make.width.equalToSuperview()
            make.height.equalTo(UIConstants.imageHeight)
        }
        contentCardView.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.6)
            make.leading.equalToSuperview().offset(UIConstants.titleLabelLeadingOffset)
            make.top.equalTo(placeImage.snp.bottom).offset(UIConstants.titleLabelTopOffset)
            make.height.equalTo(UIConstants.titleLabelHeight)
        }
        
        contentCardView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalTo(titleLabel.snp.leading)
            make.top.equalTo(titleLabel.snp.bottom).offset(UIConstants.descriptionLabelTopOffset)
            make.width.equalToSuperview().multipliedBy(0.6)
        }
        
        contentCardView.addSubview(distantionLabel)
        
        distantionLabel.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(placeImage.snp.bottom).offset(UIConstants.distantionLabelTopOffset)
            make.width.equalToSuperview().multipliedBy(0.3)
            make.height.equalTo(UIConstants.distantionLabelHeight)
        }
    }

    func setImageByUrl(url: String) {
        PhotosNetworkManager.loadPhoto(url: url) { [self] responseData in
            if let data = responseData {
                placeImage.image = UIImage(data: data)
            } else {
                print("не удалось загрузить фото")
            }
        }
    }
}
