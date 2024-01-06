//
//  MapMeCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

class MapMeCell: UICollectionViewCell {
    
    func configure(){
        meLabel.text = "Вы"
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
    
    private let meLabel:UILabel = {
        let label = UILabel()
        
        label.textAlignment = .center
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.adjustsFontSizeToFitWidth = true
        label.textColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))
        
        return label
    }()
}


// MARK: - Private methods
private extension MapMeCell {
    
    func initialize(){
        backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        layer.cornerRadius = 25
        clipsToBounds = true
        layer.borderColor = CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1)
        layer.borderWidth = 2
        
        addSubview(meLabel)
        
        meLabel.snp.makeConstraints { make in
            make.size.equalToSuperview().multipliedBy(0.7)
            make.center.equalToSuperview()
        }
        
        addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(focusOnUserLocation)))
    }
    
    @objc func focusOnUserLocation(){
        NotificationCenter.default.post(Notification(name: Notification.Name("focusOnUserLocation")))
    }
}
