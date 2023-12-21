//
//  SmallLabelCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 21.12.23.
//

import UIKit

class SmallLabelCell: UITableViewCell {
    
    func configure(with text: String) {
        label.text = text
    }
    
    // MARK: - Initialization
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        initializaiton()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let labelFontSize:CGFloat = 12
        static let labelHeight:CGFloat = 20
    }
    
    // MARK: - Private properties
    
    lazy private var label:UILabel = {
        let label = UILabel()
        
        label.font = .systemFont(ofSize: UIConstants.labelFontSize)
        label.textColor = .black
        label.textAlignment = .center
        
        return label
    }()
}

// MARK: - Private methods
private extension SmallLabelCell {
    func initializaiton(){
        contentView.backgroundColor = .white
        
        contentView.addSubview(label)
        
        label.snp.makeConstraints { make in
            make.top.bottom.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.height.equalTo(UIConstants.labelHeight)
        }
        
    }
}
