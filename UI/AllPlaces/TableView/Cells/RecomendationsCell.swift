//
//  RecomendationsCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 25.12.23.
//

import UIKit

class RecomendationsCell: UITableViewCell {
    // MARK: - Public
    func configure(){
        
    }

    // MARK: - Init
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Prviate methods
private extension RecomendationsCell{
    func initialize(){
        
    }
}
