//
//  SimilarPlaceCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 3.01.24.
//

import UIKit

final class SimilarPlaceCell: UICollectionViewCell {
    // MARK: - Public

    func configure(with place: GetAllPlacesRequestResponseSingleEntity) {
        placeId = place.id
        placeLabel.text = place.nameOfPlace

        PhotosNetworkManager.loadPhoto(url: place.photos.first!.photoURL) { [self] responseData in
            if let data = responseData {
                placeImageView.image = UIImage(data: data)
            } else {
                print("error loadPhoto")
            }
        }
    }

    var placeId = 0

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let imageViewHeight: CGFloat = 150
        static let labelHeight: CGFloat = 30
    }

    // MARK: - Private properties

    private let placeLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black
        label.adjustsFontSizeToFitWidth = true
        return label
    }()

    private let placeImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = 10

        return imageView
    }()
}

// MARK: - Private methods

private extension SimilarPlaceCell {
    func initialize() {
        contentView.addSubview(placeImageView)

        placeImageView.snp.makeConstraints { make in
            make.width.top.equalToSuperview()
            make.height.equalTo(UIConstants.imageViewHeight)
            make.leading.equalToSuperview().offset(10)
        }

        contentView.addSubview(placeLabel)

        placeLabel.snp.makeConstraints { make in
            make.centerX.width.equalToSuperview()
            make.top.equalTo(placeImageView.snp.bottom)
            make.height.equalTo(UIConstants.labelHeight)
            make.leading.equalToSuperview().offset(10)
        }
    }
}
