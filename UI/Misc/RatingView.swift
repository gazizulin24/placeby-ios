//
//  RatingView.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit
import SnapKit

final class RatingView: UIView {
    
    // MARK: - Public
    func configure(placeId: Int){
        self.placeId = placeId
    }
    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let closeButtonHeight:CGFloat = 50
        static let titleLabelHeight:CGFloat = 50
        static let dayViewHeight:CGFloat = 30
        static let starSize:CGFloat = 40
        static let starsOffset:CGFloat = 10
    }
    
    // MARK: - Private properties
    private var placeId = 0;
    private var placeRating = 0;
    
    lazy private var closeButton:UIButton = {
        let button = UIButton(configuration: .tinted())
        
        button.setTitleColor(.black, for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.setTitle("Оценить", for: .normal)
        button.addTarget(self, action: #selector(ratePlace), for: .touchUpInside)
        
        return button
    }()
    
    private let placeNameLabel:UILabel = {
        let label = UILabel()
        
        label.text = "Оцените место"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()
    
    private let starsView:UIView = {
        let view = UIView()
        
        
        return view
    }()
    
    lazy private var starButtons:[UIImageView] = {
        var buttons:[UIImageView] = []
        
        for _ in 1...5 {
            let button = UIImageView()
            
            button.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(rateBy(_:))))
            button.image = UIImage(systemName: "star")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            button.contentMode = .scaleAspectFit
            button.isUserInteractionEnabled = true
            
            buttons.append(button)
        }
        
        return buttons
    }()
}

// MARK: - Private methods
private extension RatingView {
    func initialize(){
        layer.cornerRadius = 10
        clipsToBounds = true
        backgroundColor = .white
        
        addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(UIConstants.closeButtonHeight)
        }
        
        addSubview(placeNameLabel)
        
        placeNameLabel.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(UIConstants.titleLabelHeight)
        }
        
        addSubview(starsView)
        
        starsView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(placeNameLabel.snp.bottom)
            make.height.equalTo(UIConstants.starSize)
            make.width.equalTo(UIConstants.starSize * 5 + UIConstants.starsOffset * 4)
        }
        
        
        
        for (i, starButton) in starButtons.enumerated() {
            starsView.addSubview(starButton)
            starButton.snp.makeConstraints { make in
                
                make.size.equalTo(UIConstants.starSize)
                if i == 0 {
                    make.leading.equalToSuperview()
                } else {
                    make.leading.equalTo(starButtons[i-1].snp.trailing).offset(UIConstants.starsOffset)
                }
            }
        }
        
        
    }
    
    
    
    @objc func rateBy(_ sender:UIGestureRecognizer) {
        guard let senderView = sender.view as? UIImageView else { return }
        guard let starId = starButtons.firstIndex(of: senderView) else { return }
        
        
        for (i, star) in starButtons.enumerated() {
            if i <= starId{
                star.image = UIImage(systemName: "star.fill")?.withTintColor(UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1)), renderingMode: .alwaysOriginal)
            } else {
                star.image = UIImage(systemName: "star")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
            }
        }
        placeRating = starId + 1
        
    }
    
    @objc func ratePlace(){
        
        if placeRating != 0 {
            NotificationCenter.default.post(name: Notification.Name("sendRatePlace"), object: placeRating)
        }
        
        for star in starButtons {
            star.image = UIImage(systemName: "star")?.withTintColor(.gray, renderingMode: .alwaysOriginal)
        }
    }
}
