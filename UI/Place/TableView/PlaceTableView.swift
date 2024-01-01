//
//  PlaceTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 1.01.24.
//

import UIKit

class PlaceTableView: UITableView {
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
private extension PlaceTableView {
    
    func initialize(){
        separatorColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        
        
        register(ImagesCell.self, forCellReuseIdentifier: String(describing: ImagesCell.self))
    }
}
