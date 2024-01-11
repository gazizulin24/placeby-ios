//
//  PlaceCategoriesCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 2.01.24.
//

import SnapKit
import UIKit

final class PlaceCategoriesCell: UITableViewCell {
    // MARK: - Public

    func configure(with place: GetAllPlacesRequestResponseSingleEntity) {
        print(place.types)
        createTypesList(types: place.types)
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
        static let categoriesLabelFontSize: CGFloat = 20
        static let categoriesLabelLeadingOffset: CGFloat = 10
        static let categoryViewHeight: CGFloat = 30
        static let categoryLabelTextFont: CGFloat = 15
        static let categoriesOffset: CGFloat = 10
        static let categoriesLabelTopOffset: CGFloat = 20
    }

    // MARK: - Private properties

    private let categoriesLabel: UILabel = {
        let label = UILabel()

        label.text = "Категории"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIConstants.categoriesLabelFontSize, weight: .bold)
        label.textColor = .black

        return label
    }()
}

// MARK: - Private methods

private extension PlaceCategoriesCell {
    func initialize() {
        contentView.backgroundColor = .white

        contentView.addSubview(categoriesLabel)

        categoriesLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIConstants.categoriesLabelLeadingOffset)
            make.top.equalToSuperview().offset(UIConstants.categoriesLabelTopOffset)
        }
    }

    func createTypesList(types: [PlaceTypeResponseEntity]) {
        var prevView = UIView()
        var countOfAddedViews = 0
        for placeType in PlaceType.basicTypes {
            var isSuggested = false
            for userType in types {
                if userType.name == placeType.dbTitle {
                    isSuggested = true
                }
            }

            if isSuggested {
                let view = createPlaceTypeView(typeName: placeType.title, isSuggested: isSuggested)

                contentView.addSubview(view)
                if countOfAddedViews == 0 {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(categoriesLabel.snp.bottom).offset(UIConstants.categoriesOffset)
                        make.height.equalTo(UIConstants.categoryViewHeight)
                        make.width.equalToSuperview().multipliedBy(0.90)
                        make.centerX.equalToSuperview()
                    }
                } else if countOfAddedViews == PlaceType.basicTypes.count - 1 {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(prevView.snp.bottom)
                        make.height.equalTo(UIConstants.categoryViewHeight)
                        make.width.equalToSuperview().multipliedBy(0.90)
                        make.centerX.equalToSuperview()
                    }
                } else {
                    view.snp.makeConstraints { make in
                        make.top.equalTo(prevView.snp.bottom)
                        make.height.equalTo(UIConstants.categoryViewHeight)
                        make.width.equalToSuperview().multipliedBy(0.90)
                        make.centerX.equalToSuperview()
                    }
                }
                countOfAddedViews += 1
                prevView = view
            }
        }
        if countOfAddedViews == 0 {
            let view = createPlaceTypeView(typeName: "Не нашли категорий для этого места", isSuggested: false)

            contentView.addSubview(view)
            view.snp.makeConstraints { make in
                make.top.equalTo(categoriesLabel.snp.bottom).offset(UIConstants.categoriesOffset)
                make.height.equalTo(UIConstants.categoryViewHeight)
                make.width.equalToSuperview().multipliedBy(0.90)
                make.centerX.equalToSuperview()
            }

            prevView = view
        }

        prevView.snp.makeConstraints { make in
            make.bottom.equalToSuperview()
        }
    }

    func createPlaceTypeView(typeName: String, isSuggested: Bool) -> UIView {
        let view = UIView()

        let viewTitleLabel = UILabel()

        viewTitleLabel.text = typeName
        viewTitleLabel.font = .systemFont(ofSize: UIConstants.categoryLabelTextFont)
        viewTitleLabel.textColor = .black
        viewTitleLabel.textAlignment = .left

        view.addSubview(viewTitleLabel)

        viewTitleLabel.snp.makeConstraints { make in
            make.leading.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.8)
        }

        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit

        if isSuggested {
            imageView.image = UIImage(systemName: "checkmark")?.withTintColor(.green, renderingMode: .alwaysOriginal)
        } else {
            imageView.image = UIImage(systemName: "xmark")?.withTintColor(.red, renderingMode: .alwaysOriginal)
        }

        view.addSubview(imageView)

        imageView.snp.makeConstraints { make in
            make.trailing.centerY.height.equalToSuperview()
        }

        return view
    }
}
