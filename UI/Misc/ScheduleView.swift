//
//  ScheduleView.swift
//  placeby
//
//  Created by Timur Gazizulin on 4.01.24.
//

import SnapKit
import UIKit

final class ScheduleView: UIView {
    // MARK: - Public

    func configure() {
        PlacesNetworkManager.getAllPlaceTimetable(placeId: UserDefaults.standard.integer(forKey: "placeId")) { [self] responseEntity in
            if let timetable = responseEntity?.timetable {
                removeOldSchedule()
                createTimetable(timetable: timetable)
            } else {
                print("error getAllPlaceTimetable")
            }
        }
    }

    // MARK: - Init

    override init(frame: CGRect) {
        super.init(frame: frame)
        initialize()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Private constants

    private let daysRus = ["Понедельник", "Вторник", "Среда", "Четверг", "Пятница", "Суббота", "Воскресенье"]
    private let daysOfWeek: [String: String] = [
        "monday": "Понедельник",
        "tuesday": "Вторник",
        "wednesday": "Среда",
        "thursday": "Четверг",
        "friday": "Пятница",
        "saturday": "Суббота",
        "sunday": "Воскресенье",
    ]
    private var daysViews: [UIView] = []
    private enum UIConstants {
        static let closeButtonHeight: CGFloat = 50
        static let placeNameLabelHeight: CGFloat = 40
        static let dayViewHeight: CGFloat = 30
    }

    // MARK: - Private properties

    private lazy var closeButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitleColor(.black, for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.setTitle("Закрыть", for: .normal)
        button.addTarget(self, action: #selector(closeScheduleView), for: .touchUpInside)

        return button
    }()

    private let placeNameLabel: UILabel = {
        let label = UILabel()

        label.text = "Расписание"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textColor = .black
        label.textAlignment = .center

        return label
    }()
}

// MARK: - Private methods

private extension ScheduleView {
    func initialize() {
        backgroundColor = .white
        clipsToBounds = true
        layer.cornerRadius = 10

        addSubview(closeButton)

        closeButton.snp.makeConstraints { make in
            make.bottom.centerX.width.equalToSuperview()
            make.height.equalTo(UIConstants.closeButtonHeight)
        }

        addSubview(placeNameLabel)

        placeNameLabel.snp.makeConstraints { make in
            make.centerX.width.top.equalToSuperview()
            make.height.equalTo(UIConstants.placeNameLabelHeight)
        }
    }

    func createTimetable(timetable: [Timetable]) {
        for (i, day) in timetable.enumerated() {
            let timeOpen = String(day.startTime.dropLast(3))
            let timeClose = String(day.endTime.dropLast(3))
            let dayName = daysOfWeek[day.dayOfWeek]!
            var scheduleString = "\(timeOpen) - \(timeClose)"

            if timeOpen == timeClose, timeOpen == "00:00" {
                scheduleString = "Выходной"
            }

            if timeOpen == "00:00", timeClose == "23:59" {
                scheduleString = "Круглосуточно"
            }

            let view = createDayScheduleView(day: dayName, time: scheduleString)

            addSubview(view)
            print(dayName)
            view.snp.makeConstraints { make in
                make.height.equalTo(UIConstants.dayViewHeight)
                make.width.equalToSuperview().multipliedBy(0.9)
                make.centerX.equalToSuperview()
                if i == 0 {
                    make.top.equalTo(placeNameLabel.snp.bottom)
                } else {
                    make.top.equalTo(daysViews[i - 1].snp.bottom)
                }
            }
            daysViews.append(view)
        }
    }

    func removeOldSchedule() {
        for view in daysViews {
            view.removeFromSuperview()
        }
        daysViews = []
    }

    @objc func closeScheduleView() {
        NotificationCenter.default.post(Notification(name: Notification.Name("closeSchedule")))
    }

    func createDayScheduleView(day: String, time: String) -> UIView {
        let view = UIView()

        let dayLabel = UILabel()
        dayLabel.text = day
        dayLabel.font = .systemFont(ofSize: 15, weight: .bold)
        dayLabel.textColor = .black
        dayLabel.textAlignment = .left

        view.addSubview(dayLabel)

        dayLabel.snp.makeConstraints { make in
            make.height.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }

        let timeLabel = UILabel()
        timeLabel.text = time
        timeLabel.font = .systemFont(ofSize: 15, weight: .bold)
        timeLabel.textColor = .black
        timeLabel.textAlignment = .right

        view.addSubview(timeLabel)

        timeLabel.snp.makeConstraints { make in
            make.height.trailing.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.5)
        }
        return view
    }
}
