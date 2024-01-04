//
//  ReportPlaceCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 3.01.24.
//

import UIKit
import SnapKit

final class ReportPlaceCell: UITableViewCell {
    
    // MARK: - Public
    func configure(with placeName:String) {
        self.placeName = placeName
        smallTextLabel.text = "placeby не несет ответственности за действия происходящие в \(placeName) и других местах. Мы лишь показываем куда можно сходить прогуляться :)"
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
    private enum UIConstants {
        static let buttonHeight:CGFloat = 30
        static let topOffset:CGFloat = 10
        static let reportPlaceLabelFontSize:CGFloat = 20
        static let smallLabelFontSize:CGFloat = 12
        static let smallLabelHeight:CGFloat = 50
    }
    
    // MARK: - Private properties
    private var placeName = ""
    
    lazy private var reportButton:UIButton = {
        let button = UIButton(configuration: .tinted())
        
        button.tintColor = .darkGray
        button.setTitleColor(.black, for: .normal)
        button.setTitle("Пожаловаться на место", for: .normal)
        
        button.addTarget(self, action: #selector(tapReportButton), for: .touchUpInside)
        return button
    }()
    
    private let reportPlaceLabel:UILabel = {
        let label = UILabel()
        
        label.text = "Что-то не понравилось?"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIConstants.reportPlaceLabelFontSize, weight: .bold)
        label.textColor = .black
        
        return label
    }()
    private lazy var smallTextLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.smallLabelFontSize)
        label.textColor = .black
        label.textAlignment = .left
        label.numberOfLines = 3

        return label
    }()
    
}
// MARK: - Private methods
private extension ReportPlaceCell {
    
    func initialize(){
        contentView.backgroundColor = .white
        
        contentView.addSubview(reportPlaceLabel)
        
        reportPlaceLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIConstants.topOffset)
            make.top.equalToSuperview().offset(UIConstants.topOffset)
        }
        
        
        contentView.addSubview(reportButton)
        
        reportButton.snp.makeConstraints { make in
            make.top.equalTo(reportPlaceLabel.snp.bottom).offset(UIConstants.topOffset/1.5)
            make.leading.equalTo(reportPlaceLabel.snp.leading)
            make.height.equalTo(UIConstants.buttonHeight)
            make.width.equalToSuperview().multipliedBy(0.6)
            
        }
        
        
        contentView.addSubview(smallTextLabel)
        
        smallTextLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.height.equalTo(UIConstants.smallLabelHeight)
            make.width.equalToSuperview().multipliedBy(0.95)
            make.top.equalTo(reportButton.snp.bottom).offset(UIConstants.topOffset/2)
            make.bottom.equalToSuperview()
        }
    }
    
    @objc func tapReportButton(){
        UserDefaults.standard.setValue(placeName, forKey: "placeNameToReport")
        NotificationCenter.default.post(name: Notification.Name("openFeedback"), object: nil)
    }
}
