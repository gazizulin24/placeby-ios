//
//  RecentlyPlaceCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 28.12.23.
//

import UIKit

final class RecentlyPlaceCell: UITableViewCell {
    // MARK: - Public

    func configure(with place: RecentlyPlaceData) {
        placeId = place.id
        placeNameLabel.text = place.name
        setImageByUrl(url: place.imageUrl)
    }

    // MARK: - Init

    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private properties
    private var placeId = 0

    private let dataView: UIView = {
        let view = UIView()

        view.backgroundColor = UIColor(cgColor: CGColor(red: 250 / 255, green: 241 / 255, blue: 204 / 255, alpha: 1))
        view.layer.cornerRadius = 10
        view.clipsToBounds = true
        
        return view
    }()

    private let placeImageView: UIImageView = {
        let imageView = UIImageView()

        imageView.image = UIImage(named: "mrk")

        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        return imageView
    }()

    private let placeNameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.text = "МРК"
        label.textAlignment = .center
        return label
    }()
}

// MARK: - Private methods

private extension RecentlyPlaceCell {
    func initialize() {
        contentView.backgroundColor = .white

        dataView.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(openPlace)))
        
        contentView.addSubview(dataView)

        dataView.snp.makeConstraints { make in
            make.height.equalTo(100)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.top.bottom.equalToSuperview().multipliedBy(0.9)
        }

        dataView.addSubview(placeImageView)

        placeImageView.snp.makeConstraints { make in
            make.centerY.trailing.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
        }

        dataView.addSubview(placeNameLabel)

        placeNameLabel.snp.makeConstraints { make in
            make.centerY.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.55)
            make.leading.equalToSuperview()
        }
    }

    @objc func openPlace(){
        UserDefaults.standard.setValue(placeId, forKey: "placeId")
        
        NotificationCenter.default.post(name: Notification.Name("findPlace"), object: nil)
    }
    
    func setImageByUrl(url: String) {
        PhotosNetworkManager.loadPhoto(url: url) { [self] responseData in
            if let data = responseData {
                placeImageView.image = UIImage(data: data)
            } else {
                print("не удалось загрузить фото")
            }
        }
    }
}
