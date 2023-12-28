//
//  LoadingCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 27.12.23.
//

import UIKit

class LoadingCell: UITableViewCell {
    // MARK: - Public
    
    func reloadIndicator(){
        indicator.startAnimating()
    }
    
    
    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Private properties
    
    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.color = .black

        return indicator
    }()
    
}
// MARK: - Private methods
private extension LoadingCell {
    
    func initialize(){
        contentView.addSubview(indicator)
        contentView.backgroundColor = .white
        
        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
    }
}
