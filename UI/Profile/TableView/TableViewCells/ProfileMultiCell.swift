//
//  ProfileMultiCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 20.12.23.
//

import UIKit

class ProfileMultiCell: UITableViewCell {
    
    func configure(with multiCell: ProfileTableViewCellTypeMultiCell) {
        if multiCell.count != 2 {
            print("error multicell cells count must be 2")
            return
        }
        
        switch multiCell.first! {
        case .multiCellSubcell(let title, let imageName, let notificationName):
            changeFirstSubcell(title: title, imageName: imageName, notificationName:notificationName)
        default:
            print("wrong subcell type")
            return
        }
        
        switch multiCell.last! {
        case .multiCellSubcell(let title, let imageName, let notificationName):
            changeSecondSubcell(title: title, imageName: imageName, notificationName:notificationName)
        default:
            print("wrong subcell type")
            return
        }
    }
    
    
    
    
    

    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initialization()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let subcellWidth:CGFloat = 170
        static let subcellHeight:CGFloat = 135
        static let subcellsOffset:CGFloat = 100
        static let subcellCornerRadius:CGFloat = 15
        static let subcellImageSize:CGFloat = 60
        static let subcellFontSize:CGFloat = 12
        static let subcellImageToTextOffset:CGFloat = 10
    }
    
    private enum UIColorConstants {
        static let subcellBackgroundColor:UIColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 0.7))
        static let subcellTitleColor:UIColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))
        static let subcellImageColor:UIColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))
    }
    
    // MARK: - Private properties
    
    private var firstCellNotificationName:String?
    
    private var secondCellNotificationName:String?
    
    lazy private var firstSubcellView:UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColorConstants.subcellBackgroundColor
        
        view.layer.cornerRadius = UIConstants.subcellCornerRadius
        
        view.addSubview(firstSubcellImageView)
        
        firstSubcellImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.size.equalTo(UIConstants.subcellImageSize)
        }
        
        view.addSubview(firstSubcellLabel)
        
        firstSubcellLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(firstSubcellImageView.snp.bottom).offset(UIConstants.subcellImageToTextOffset)
            make.width.equalToSuperview().multipliedBy(0.8)}
        
        return view
        
    }()
    
    private let firstSubcellImageView:UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var firstSubcellLabel:UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIConstants.subcellFontSize)
        label.textAlignment = .center
        label.textColor = UIColorConstants.subcellTitleColor
        
        return label
    }()
    
    
    lazy private var secondSubcellView:UIView = {
        let view = UIView()
        
        view.backgroundColor = UIColorConstants.subcellBackgroundColor
        
        view.layer.cornerRadius = UIConstants.subcellCornerRadius
        
        view.addSubview(secondSubcellImageView)
        
        secondSubcellImageView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.centerY.equalToSuperview().offset(-10)
            make.size.equalTo(UIConstants.subcellImageSize)
        }
        
        view.addSubview(secondSubcellLabel)
        
        secondSubcellLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(secondSubcellImageView.snp.bottom).offset(UIConstants.subcellImageToTextOffset)
            make.width.equalToSuperview().multipliedBy(0.8)}
        
        return view
    }()
    
    private let secondSubcellImageView:UIImageView = {
        let imageView = UIImageView()
        
        imageView.contentMode = .scaleAspectFit
        return imageView
    }()
    
    lazy private var secondSubcellLabel:UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIConstants.subcellFontSize)
        label.textAlignment = .center
        label.textColor = UIColorConstants.subcellTitleColor
        
        return label
    }()
}


private extension ProfileMultiCell {
    
    func changeFirstSubcell(title:String, imageName:String, notificationName:String){
        
        firstSubcellImageView.image = UIImage(systemName: imageName)?.withTintColor(UIColorConstants.subcellImageColor, renderingMode: .alwaysOriginal)
        
        firstCellNotificationName = notificationName
        
        firstSubcellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(firstCellAction)))
        firstSubcellLabel.text = title
    }
    
    @objc func firstCellAction() {
        if let notificationName = firstCellNotificationName{
            NotificationCenter.default.post(Notification(name: Notification.Name(notificationName)))
        }
    }
    
    
    func changeSecondSubcell(title:String, imageName:String, notificationName:String){
        
        secondSubcellImageView.image = UIImage(systemName: imageName)?.withTintColor(UIColorConstants.subcellImageColor, renderingMode: .alwaysOriginal)
        
        secondCellNotificationName = notificationName
        
        secondSubcellView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(secondCellAction)))
        secondSubcellLabel.text = title
    }
    
    @objc func secondCellAction(){
        if let notificationName = secondCellNotificationName{
            NotificationCenter.default.post(Notification(name: Notification.Name(notificationName)))
        }
    }
    
    func initialization() {
        
        contentView.backgroundColor = .white
        
        contentView.addSubview(firstSubcellView)
        
        firstSubcellView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(-UIConstants.subcellsOffset)
            make.height.equalTo(UIConstants.subcellHeight)
            make.width.equalTo(UIConstants.subcellWidth)
            make.bottom.top.equalToSuperview().multipliedBy(0.9)
            
        }
        
        contentView.addSubview(secondSubcellView)
        
        secondSubcellView.snp.makeConstraints { make in
            make.centerX.equalToSuperview().offset(UIConstants.subcellsOffset)
            make.height.equalTo(UIConstants.subcellHeight)
            make.width.equalTo(UIConstants.subcellWidth)
            make.bottom.top.equalToSuperview().multipliedBy(0.9)
            
        }
    }
}
