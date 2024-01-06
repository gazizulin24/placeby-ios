//
//  GlobalSettingsTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 6.01.24.
//

import UIKit

final class GlobalSettingsTableView: UITableView {
    
    override init(frame: CGRect, style: UITableView.Style) {
        super.init(frame: frame, style: style)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}

private extension GlobalSettingsTableView {
    func initialize(){
        backgroundColor = .white
        separatorColor = .clear
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        register(PlacesNearbySettingsCell.self, forCellReuseIdentifier: String(describing: PlacesNearbySettingsCell.self))
    }
}
