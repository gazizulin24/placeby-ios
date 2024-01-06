//
//  PlacesMapTopView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit
import SnapKit

final class PlacesMapTopView: UIView {
    
    // MARK: - Public
    
    func backConfigure(placeId:Int){
        self.placeId = placeId
        titleLabel.text = "Вернуться?"
    }
    
    func configure(with place:GetAllPlacesRequestResponseSingleEntity){
        placeId = place.id
        titleLabel.text = "Открыть \(place.nameOfPlace)?"
    }

    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    private var placeId = 0
    
    lazy private var closeButton:UIButton = {
        let button = UIButton(configuration: .tinted())

        button.tintColor = .red
        button.setImage(UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(close), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
    private let titleLabel:UILabel = {
        let label = UILabel()
        
        label.textColor = .black
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 16, weight: .bold)
        label.numberOfLines = 2
        label.adjustsFontSizeToFitWidth = true
        
        return label
    }()
    
    lazy private var openButton:UIButton = {
        let button = UIButton(configuration: .tinted())

        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.setImage(UIImage(systemName: "checkmark")?.withTintColor(UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1)), renderingMode: .alwaysOriginal), for: .normal)
        button.addTarget(self, action: #selector(openPlace), for: .touchUpInside)
        button.layer.cornerRadius = 20
        button.clipsToBounds = true
        return button
    }()
    
}

// MARK: - Private methods
private extension PlacesMapTopView {
    func initialize(){
        backgroundColor = .white
        layer.cornerRadius = 15
        clipsToBounds = true
        
        addSubview(closeButton)
        
        closeButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.leading.equalToSuperview().offset(10)
            make.size.equalTo(40)
        }
        
        
        addSubview(openButton)
        
        openButton.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.trailing.equalToSuperview().inset(10)
            make.size.equalTo(40)
        }
        
        addSubview(titleLabel)
        
        titleLabel.snp.makeConstraints { make in
            make.center.equalToSuperview()
            make.height.equalTo(40)
            make.width.equalToSuperview().multipliedBy(0.7)
        }
        
    }
    
    @objc func close(){
        NotificationCenter.default.post(name: Notification.Name("closeTopMapView"), object: nil)
    }
    
    @objc func openPlace(){
        UserDefaults.standard.setValue(placeId, forKey: "placeId")
        NotificationCenter.default.post(name: Notification.Name("openPlaceFromTopMapView"), object: nil)
    }
}
