//
//  PlaceScheduleCell.swift
//  placeby
//
//  Created by Timur Gazizulin on 4.01.24.
//

import UIKit

final class PlaceScheduleCell: UITableViewCell {
    // MARK: - Public

    func configure(with place: GetAllPlacesRequestResponseSingleEntity) {
        print(place)

        guard let timetable = place.todayTimetable else { return }
        let timeOpen = String(timetable.startTime.dropLast(3))
        let timeClose = String(timetable.endTime.dropLast(3))

        let isOpen = place.isOpen ?? false

        if !isOpen {
            isOpenLabel.text = "Закрыто"
            isOpenLabel.textColor = UIColor(cgColor: CGColor(red: 240 / 255, green: 27 / 255, blue: 32 / 255, alpha: 1))
        }
        var scheduleString = "\(timeOpen) - \(timeClose)"

        if (timeOpen == timeClose) && (timeOpen == "00:00") {
            scheduleString = "Выходной"
        }

        if (timeOpen == "00:00") && (timeClose == "23:59") {
            scheduleString = "Круглосуточно"
        }
//
//        let attributedText = NSAttributedString(string: scheduleString, attributes: [NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue])
//

        scheduleTimeLabel.text = scheduleString
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
        static let schedulePlacesLabelFontSize: CGFloat = 20
        static let leadingOffset: CGFloat = 10
        static let topOffset: CGFloat = 10
        static let scheduleViewHeight: CGFloat = 25
        static let scheduleViewLabelsFontSize: CGFloat = 20
    }

    private let scheduleLabel: UILabel = {
        let label = UILabel()

        label.text = "Расписание"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIConstants.schedulePlacesLabelFontSize, weight: .bold)
        label.textColor = .black

        return label
    }()

    private let isOpenLabel: UILabel = {
        let label = UILabel()

        label.text = "Открыто"
        label.textAlignment = .left
        label.font = .systemFont(ofSize: UIConstants.scheduleViewLabelsFontSize, weight: .bold)
        label.textColor = UIColor(cgColor: CGColor(red: 38 / 255, green: 225 / 255, blue: 32 / 255, alpha: 1))

        return label
    }()

    private let scheduleTimeLabel: UILabel = {
        let label = UILabel()

        label.text = "00.00 - 00.00"
        label.textAlignment = .right
        label.font = .systemFont(ofSize: UIConstants.scheduleViewLabelsFontSize, weight: .bold)
        label.textColor = .black

        return label
    }()

    private let scheduleView: UIView = {
        let view = UIView()

        return view
    }()
}

// MARK: - Private methods

private extension PlaceScheduleCell {
    func initialize() {
        contentView.backgroundColor = .white

        contentView.addSubview(scheduleLabel)

        scheduleLabel.snp.makeConstraints { make in
            make.leading.equalToSuperview().offset(UIConstants.leadingOffset)
            make.top.equalToSuperview().offset(UIConstants.topOffset)
        }

        contentView.addSubview(scheduleView)

        scheduleView.snp.makeConstraints { make in
            make.top.equalTo(scheduleLabel.snp.bottom).offset(UIConstants.topOffset)
            make.height.equalTo(UIConstants.scheduleViewHeight)
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview()
        }

        scheduleView.addSubview(isOpenLabel)

        isOpenLabel.snp.makeConstraints { make in
            make.centerY.leading.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        scheduleView.addSubview(scheduleTimeLabel)

        scheduleTimeLabel.snp.makeConstraints { make in
            make.centerY.trailing.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
    }

    @objc func openSchedule() {
        print("open")
    }
}
