//
//  RecomendationsCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 25.12.23.
//

import SnapKit
import UIKit

final class RecomendationsCell: UITableViewCell {
    // MARK: - Public

    func configure(with recomendationsData: RecomedationsData) {
        if recomendationsData.count != 3 { return }

        leftBigViewRecomendationsData = recomendationsData[0]
        rightTopViewRecomendationsData = recomendationsData[1]
        rightBottomViewRecomendationsData = recomendationsData[2]

        fillView(leftBigView, recomendationsData[0])
        fillView(rightTopView, recomendationsData[1])
        fillView(rightBottomView, recomendationsData[2])
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

    // MARK: - Private constants

    private enum UIConstants {
        static let itemsViewHeight: CGFloat = 300
        static let itemViewCornerRadius: CGFloat = 10
        static let itemsInViewOffset: CGFloat = 10
        static let labelFontSize: CGFloat = 15
        static let labelCornerRadius: CGFloat = 10
        static let labelHeight: CGFloat = 30
        static let labelBottomInset: CGFloat = 7
    }

    // MARK: - Private properties

    private var leftBigViewRecomendationsData: RecomendationsSingleData!
    private var rightTopViewRecomendationsData: RecomendationsSingleData!
    private var rightBottomViewRecomendationsData: RecomendationsSingleData!

    private let itemsView: UIView = {
        let view = UIView()
        return view
    }()

    private lazy var leftBigView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = UIConstants.itemViewCornerRadius

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(bigButtonAction)))
        return view
    }()

    private lazy var rightTopView: UIView = {
        let view = UIView()

        view.layer.cornerRadius = UIConstants.itemViewCornerRadius

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smallTopButtonAction)))
        return view
    }()

    private lazy var rightBottomView: UIView = {
        let view = UIView()

        view.backgroundColor = .gray
        view.layer.cornerRadius = UIConstants.itemViewCornerRadius

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(smallBottomButtonAction)))
        return view
    }()
}

// MARK: - Prviate methods

private extension RecomendationsCell {
    func initialize() {
        selectionStyle = .none
        contentView.backgroundColor = .white

        contentView.addSubview(itemsView)

        itemsView.snp.makeConstraints { make in
            make.width.top.equalToSuperview()
            make.height.equalTo(UIConstants.itemsViewHeight)
            make.bottom.equalToSuperview().multipliedBy(0.95)
        }

        itemsView.addSubview(leftBigView)

        leftBigView.snp.makeConstraints { make in
            make.height.top.bottom.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.45)
            make.trailing.equalTo(contentView.snp.centerX).offset(-UIConstants.itemsInViewOffset)
        }

        itemsView.addSubview(rightTopView)

        rightTopView.snp.makeConstraints { make in
            make.top.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.35)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.leading.equalTo(contentView.snp.centerX).offset(UIConstants.itemsInViewOffset)
        }

        itemsView.addSubview(rightBottomView)

        rightBottomView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
            make.height.equalToSuperview().multipliedBy(0.60)
            make.width.equalToSuperview().multipliedBy(0.45)
            make.leading.equalTo(contentView.snp.centerX).offset(UIConstants.itemsInViewOffset)
        }
    }

    func fillView(_ view: UIView, _ data: RecomendationsSingleData) {
        let imageView = UIImageView()

        imageView.image = UIImage(named: data.imageName)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.layer.cornerRadius = UIConstants.itemViewCornerRadius

        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }

        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .bold)
        label.backgroundColor = .white
        label.textAlignment = .center
        label.textColor = .black
        label.layer.cornerRadius = UIConstants.labelCornerRadius
        label.text = data.title
        label.clipsToBounds = true

        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIConstants.labelBottomInset)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.height.equalTo(UIConstants.labelHeight)
        }
    }

    @objc func bigButtonAction() {
        print("bigButtonAction")
        PlaceType.savePlaceTypeToUserDefaults(placeType: PlaceType(title: leftBigViewRecomendationsData.title, dbTitle: leftBigViewRecomendationsData.placesType))
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }

    @objc func smallTopButtonAction() {
        print("smallTopButtonAction")
        PlaceType.savePlaceTypeToUserDefaults(placeType: PlaceType(title: rightTopViewRecomendationsData.title, dbTitle: rightTopViewRecomendationsData.placesType))
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }

    @objc func smallBottomButtonAction() {
        print("smallBottomButtonAction")
        PlaceType.savePlaceTypeToUserDefaults(placeType: PlaceType(title: rightBottomViewRecomendationsData.title, dbTitle: rightBottomViewRecomendationsData.placesType))
        NotificationCenter.default.post(name: Notification.Name("allPlacesFilterTypeChanged"), object: nil)
    }
}
