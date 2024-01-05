//
//  FavouritePlaceCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit

class FavouritePlaceCell: UITableViewCell {

    // MARK: - Public

    func configure(with place: GetAllPlacesRequestResponseSingleEntity) {
        placeId = place.id
        placeNameLabel.text = place.nameOfPlace
        setImageByUrl(url: place.photos.first!.photoURL)
    }
    var placeId = 0

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

    private let placeImageView: UIImageView = {
        let imageView = UIImageView()


        imageView.contentMode = .scaleAspectFill
        imageView.layer.cornerRadius = 10
        imageView.clipsToBounds = true
        return imageView
    }()

    private let placeNameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "МРК"
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.textAlignment = .center
        return label
    }()
}

// MARK: - Private methods

private extension FavouritePlaceCell {
    func initialize() {
        contentView.backgroundColor = .white

        contentView.addSubview(placeImageView)

        placeImageView.snp.makeConstraints { make in
            make.centerX.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(200)
        }

        contentView.addSubview(placeNameLabel)

        placeNameLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.9)
            make.top.equalTo(placeImageView.snp.bottom).offset(5)
            make.height.equalTo(20)
            make.bottom.equalToSuperview().inset(15)
        }
    }
    
    func setImageByUrl(url: String) {
        PhotosNetworkManager.loadPhoto(url: url) { [self] responseData in
            if let data = responseData {
                placeImageView.image = UIImage(data: data)
            } else {
                print("не удалось загрузить фото")
            }
        }
    }
}
