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
        
        rateLabel.text = "5.0"

        titleLabel.text = place.nameOfPlace
        descriptionLabel.text = place.description
        placeId = place.id
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
        static let rateViewTopOffset:CGFloat = 5
        static let distantionLabelHeight:CGFloat = 60
        static let rateLabelFontSize:CGFloat = 20
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
    
    private let rateLabel:UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.textColor = UIColor(cgColor: CGColor(red: 51 / 255, green: 51 / 255, blue: 51 / 255, alpha: 1))
        label.font = .systemFont(ofSize: UIConstants.rateLabelFontSize, weight: .bold)
        
        return label
    }()
    
    
    private let starImage:UIImageView = {
        let imageView = UIImageView()
        
        imageView.image = UIImage(systemName: "star.fill")?.withTintColor(UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1)), renderingMode: .alwaysOriginal)
        imageView.contentMode = .scaleAspectFit
        
        return imageView
    }()
    
    private let rateView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        return view
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
        
        contentCardView.addSubview(rateView)
        
        rateView.snp.makeConstraints { make in
            make.trailing.equalToSuperview()
            make.top.equalTo(placeImage.snp.bottom).offset(UIConstants.rateViewTopOffset)
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(UIConstants.distantionLabelHeight)
        }
        
        rateView.addSubview(starImage)
        
        starImage.snp.makeConstraints { make in
            make.trailing.centerY.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        
        rateView.addSubview(rateLabel)
        
        rateLabel.snp.makeConstraints { make in
            make.leading.top.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
            
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
