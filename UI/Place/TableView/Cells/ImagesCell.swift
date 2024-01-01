//
//  ImagesCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 1.01.24.
//

import UIKit

final class ImagesCell: UITableViewCell {
    
    // MARK: - Public
    func configure(images: [PlacePhotoResponseEntity]) {
        imagesScrollView.contentSize = CGSize(width: UIScreen.main.bounds.width * CGFloat(images.count), height: UIConstants.scrollViewHeight)
        
        imagesScrollView.addImages(images: images)
        
        countOfPages = images.count
        createDotsInDotsView(count: countOfPages, selectedDot: 0)
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
        static let scrollViewHeight:CGFloat = 150
        static let dotSize:CGFloat = 10
        static let dotsOffset:CGFloat = 10
        static let dotsViewHeight:CGFloat = 30
    }
    
    // MARK: - Private properties
    
    private var countOfPages = 0
    
    lazy private var imagesScrollView:PlaceImagesScrollView = {
        let scrollView = PlaceImagesScrollView()
        
        scrollView.backgroundColor = .white
        scrollView.delegate = self
        
        return scrollView
    }()
    
    private var dotsView:UIView = {
        let view = UIView()
        
        view.backgroundColor = .white
        return view
    }()
    
}

// MARK: - Private methods
private extension ImagesCell {
    
    func initialize(){
        contentView.addSubview(imagesScrollView)
        contentView.backgroundColor = .white
        
        imagesScrollView.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(300)
        }
        
        contentView.addSubview(dotsView)
        
        dotsView.snp.makeConstraints { make in
            make.top.equalTo(imagesScrollView.snp.bottom)
            make.centerX.width.bottom.equalToSuperview()
            make.height.equalTo(UIConstants.dotsViewHeight)
        }
        
        
        
    }
    
    func createDotsInDotsView(count:Int, selectedDot:Int){
        let view = UIView()
        view.backgroundColor = .white
        
        if let prevView = view.subviews.last {
            prevView.removeFromSuperview()
        }
        
        dotsView.addSubview(view)
        
        let dotSize:Double = UIConstants.dotSize
        let dotsOffset:Double = UIConstants.dotsOffset
        
        let viewWidth = (Double(count) * dotSize) + (dotsOffset * Double(count - 1))
        
        view.snp.makeConstraints { make in
            make.center.height.equalToSuperview()
            make.width.equalTo( CGFloat(viewWidth) )
        }
        
        var prevDot = UIView()
        for i in 0..<count {
            let dot = UIView()
            
            dot.backgroundColor = .lightGray
            
            dot.layer.cornerRadius = Double(UIConstants.dotSize)/2
            
            
            if i == selectedDot {
                dot.backgroundColor = .darkGray
            }
            view.addSubview(dot)
            
            if i == 0 {
                dot.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalToSuperview()
                    make.size.equalTo(10)
                }
            } else{
                dot.snp.makeConstraints { make in
                    make.centerY.equalToSuperview()
                    make.leading.equalTo(prevDot.snp.trailing).offset(10)
                    make.size.equalTo(10)
                }
            }
            
            prevDot = dot
        }
    }
    
    
    func getImagesFromResponseEntities(_ entities: [PlacePhotoResponseEntity]) -> [UIImage?] {
        var images:[UIImage?] = []
        
        for photoReseponseEntity in entities {
            
            PhotosNetworkManager.loadPhoto(url: photoReseponseEntity.photoURL) { responseData in
                if let data = responseData {
                    images.append(UIImage(data: data))
                }
            }
        }
        
        
        return images
    }
}

extension ImagesCell: UIScrollViewDelegate {
    
        func scrollViewDidEndDecelerating(_ scrollView: UIScrollView) {
            let currentPage = Int(scrollView.contentOffset.x / scrollView.bounds.width)
            
            
            
            print(currentPage)
            print(countOfPages)
            createDotsInDotsView(count: countOfPages, selectedDot: currentPage)
        }
}
