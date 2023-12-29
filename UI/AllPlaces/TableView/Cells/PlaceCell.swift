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

    func configure(with place: Place) {
        placeImage.image = UIImage(named: place.images.first!)
        titleLabel.text = place.name
        self.place = place
    }

    func configureWithPhotoUrl(place: Place, photoUrl: String) {
        titleLabel.text = place.name
        setImageByUrl(url: photoUrl)
        self.place = place
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

    var place = Place(placeId: 0, name: "", description: "", distantion: "", images: [], coordinates: PlaceCoordinates(latitude: 0, longitude: 0))

    // MARK: - Private constant

    private enum UIConstants {
        static let cellWidth: CGFloat = 350
        static let imageHeight: CGFloat = 250
        static let titleLabelFontSize: CGFloat = 15
        static let cellHeight: CGFloat = 300
        static let titleLabelHeight: CGFloat = 30
        static let locationLabelFontSize: CGFloat = 10
        static let contentCardViewInsetOffset: CGFloat = 10
        static let contentCardViewWidthMultiplier: CGFloat = 0.95
        static let contentCardViewCornerRadius: CGFloat = 10
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
        label.textAlignment = .center

        return label
    }()

    private let locationLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center

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
            make.height.equalTo(UIConstants.imageHeight)
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
            make.width.equalToSuperview()
            make.centerX.equalToSuperview()
            make.top.equalTo(placeImage.snp.bottom)
            make.height.equalTo(UIConstants.titleLabelHeight)
            make.bottom.equalToSuperview()
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
