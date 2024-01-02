//
//  PlaceDescriptionCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 2.01.24.
//

import UIKit
import SnapKit

final class PlaceDescriptionCell: UITableViewCell {
    
    // MARK: - Public
    func configure(with place:GetAllPlacesRequestResponseSingleEntity){
        titleLabel.text = place.nameOfPlace
        descriptionLabel.text = place.description
        rateLabel.text = "5.0"
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    private enum UIConstants{
        static let titleLabelFontSize:CGFloat = 40
        static let rateLabelFontSize:CGFloat = 20
        static let titleLabelLeadingOffset:CGFloat = 10
        static let descriptionLabelFontSize:CGFloat = 20
        static let descriptionLabelHeight:CGFloat = 50
        static let titleLabelHeight:CGFloat = 50
        
    }
    
    // MARK: - Private properties
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIConstants.titleLabelFontSize, weight: .bold)
        label.textAlignment = .left
        label.textColor = .black
        
        return label
    }()
    
    private let descriptionLabel:UILabel = {
        let label = UILabel()
        
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        label.font = .systemFont(ofSize: UIConstants.descriptionLabelFontSize, weight: .bold)
        label.textAlignment = .left
        label.textColor = .darkGray
        
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
private extension PlaceDescriptionCell {
    func initialize() {
        contentView.backgroundColor = .white
        
        contentView.addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.leading.equalToSuperview().offset(UIConstants.titleLabelLeadingOffset)
            make.width.equalToSuperview().multipliedBy(0.75)
            make.height.equalTo(UIConstants.titleLabelHeight)
        }
        
        contentView.addSubview(descriptionLabel)
        
        descriptionLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIConstants.titleLabelLeadingOffset)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.top.equalTo(titleLabel.snp.bottom)
            make.height.equalTo(UIConstants.descriptionLabelHeight)
            make.bottom.equalToSuperview()
        }
        
        contentView.addSubview(rateView)
        
        rateView.snp.makeConstraints { make in
            make.trailing.equalToSuperview().inset(UIConstants.titleLabelLeadingOffset)
            make.top.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.2)
            make.height.equalTo(UIConstants.titleLabelHeight)
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
    
}
