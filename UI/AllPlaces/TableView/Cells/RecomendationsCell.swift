//
//  RecomendationsCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 25.12.23.
//

import UIKit
import SnapKit

class RecomendationsCell: UITableViewCell {
    // MARK: - Public

    func configure() {}

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
        static let itemsViewHeight:CGFloat = 300
        static let itemViewCornerRadius:CGFloat = 10
        static let itemsInViewOffset:CGFloat = 10
    }
    
    // MARK: - Private properties
    
    private let itemsView:UIView = {
        let view = UIView()
        return view
    }()
    
    lazy private var leftBigView:UIView = {
        let view = UIView()
        
        view.layer.cornerRadius = UIConstants.itemViewCornerRadius
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "dostop")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.itemViewCornerRadius
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bigButtonAction)))
        return view
    }()
    
    lazy private var rightTopView:UIView = {
        let view = UIView()
        
        
        view.layer.cornerRadius = UIConstants.itemViewCornerRadius
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "para")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.itemViewCornerRadius
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smallTopButtonAction)))
        return view
    }()
    
    lazy private var rightBottomView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .gray
        view.layer.cornerRadius = UIConstants.itemViewCornerRadius
        
        let imageView = UIImageView()
        
        imageView.image = UIImage(named: "happy-family")
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.itemViewCornerRadius
        
        view.addSubview(imageView)
        
        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
        
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smallBottomButtonAction)))
        return view
    }()
}

// MARK: - Prviate methods

private extension RecomendationsCell {
    func initialize() {
        selectionStyle = .none
        contentView.backgroundColor = .white
        
        contentView.addSubview(itemsView)
        
        itemsView.snp.makeConstraints { make in
            make.width.top.equalToSuperview()
            make.height.equalTo(UIConstants.itemsViewHeight)
            make.bottom.equalToSuperview().multipliedBy(0.95)
        }
        
        itemsView.addSubview(leftBigView)
        
        
        leftBigView.snp.makeConstraints { make in
            make.height.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.trailing.equalTo(contentView.snp.centerX).offset(-UIConstants.itemsInViewOffset)
        }
        
        itemsView.addSubview(rightTopView)
        
        rightTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.leading.equalTo(contentView.snp.centerX).offset(UIConstants.itemsInViewOffset)
        }
        
        itemsView.addSubview(rightBottomView)
        
        rightBottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.60)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.leading.equalTo(contentView.snp.centerX).offset(UIConstants.itemsInViewOffset)
        }
    }
    
    @objc func bigButtonAction(){
        print("bigButtonAction")
        PlaceType.savePlaceTypeToUserDefaults(placeType: PlaceType(title: "Знаковые места", dbTitle: "attracitons"))
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }
    
    
    @objc func smallTopButtonAction(){
        print("smallTopButtonAction")
        PlaceType.savePlaceTypeToUserDefaults(placeType: PlaceType(title: "Парой", dbTitle: "pair"))
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }
    
    @objc func smallBottomButtonAction(){
        print("smallBottomButtonAction")
        PlaceType.savePlaceTypeToUserDefaults(placeType: PlaceType(title: "Семьей", dbTitle: "family"))
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }
}
