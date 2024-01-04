//
//  PlaceTableView.swift
//  placeby
//
//  Created by Timur Gazizulin on 1.01.24.
//

import UIKit

final class PlaceTableView: UITableView {
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
        register(PlaceCategoriesCell.self, forCellReuseIdentifier: String(describing: PlaceCategoriesCell.self))
        register(PlaceDescriptionCell.self, forCellReuseIdentifier: String(describing: PlaceDescriptionCell.self))
        register(PlaceMapCell.self, forCellReuseIdentifier: String(describing: PlaceMapCell.self))
        register(ReportPlaceCell.self, forCellReuseIdentifier: String(describing: ReportPlaceCell.self))
        register(SimilarPlacesCell.self, forCellReuseIdentifier: String(describing: SimilarPlacesCell.self))
        register(SmallLabelCell.self, forCellReuseIdentifier: String(describing: SmallLabelCell.self))
        register(PlaceScheduleCell.self, forCellReuseIdentifier: String(describing: PlaceScheduleCell.self))
    }
}
