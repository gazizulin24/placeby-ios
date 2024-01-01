//
//  PlaceImagesScrollView.swift
//  placeby
//
//  Created by Timur Gazizulin on 1.01.24.
//

import UIKit

class PlaceImagesScrollView: UIScrollView {
    
    // MARK: - Public
    func addImages(images: [PlacePhotoResponseEntity]){
        var prevImageView = UIImageView()
        for (num, image) in images.enumerated(){
            
            let imageView = UIImageView()
            PhotosNetworkManager.loadPhoto(url: image.photoURL) { responseData in
                if let data = responseData {
                    imageView.image = UIImage(data: data)
                }
            }
            imageView.contentMode = .scaleAspectFill
            imageView.layer.cornerRadius = 10
            imageView.clipsToBounds = true
            imageView.backgroundColor = .lightGray
            
            addSubview(imageView)
            
            if num == 0{
                imageView.snp.makeConstraints { make in
                    make.leading.equalToSuperview()
                    make.height.width.equalToSuperview()
                }
            } else{
                imageView.snp.makeConstraints { make in
                    make.leading.equalTo(prevImageView.snp.trailing)
                    make.height.width.equalToSuperview()
                }
            }
            prevImageView = imageView
            
            
        }
    }

    
    // MARK: - Init
    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}


// MARK: - Private methods
private extension PlaceImagesScrollView {
    func initialize(){
        showsVerticalScrollIndicator = false
        showsHorizontalScrollIndicator = false
        isPagingEnabled = true
        backgroundColor = .lightGray
        indicatorStyle = .white
    }
}
