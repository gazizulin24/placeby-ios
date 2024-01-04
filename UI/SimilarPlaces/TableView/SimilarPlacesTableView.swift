//
//  SimilarPlacesTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit

class SimilarPlacesTableView: UITableView {
    // MARK: - Init
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

// MARK: - Private methods
private extension SimilarPlacesTableView {
    
    func initialize(){
        separatorColor = .clear
        backgroundColor = .white
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        
        register(SimilarPlaceSingleCell.self, forCellReuseIdentifier: String(describing: SimilarPlaceSingleCell.self))
    }
}
