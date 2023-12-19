//
//  CountOfPeopleViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import SnapKit
import UIKit

final class CountOfPeopleViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let smileLabelFontSize: CGFloat = 70
        static let helloLabelFontSize: CGFloat = 20
    }

    // MARK: - Private properties

    private let smileLabel: UILabel = {
        let label = UILabel()

        label.text = "🧐"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIConstants.smileLabelFontSize)
        return label
    }()

    private let helloLabel: UILabel = {
        let label = UILabel()

        label.text = "Сколько людей пойдут на прогулку?"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: UIConstants.helloLabelFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var singleButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Пойду один", for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

        return button
    }()

    private lazy var pairButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Пойдем парой", for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

        return button
    }()

    private lazy var companyButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Пойдем компанией", for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(continueButtonPressed), for: .touchUpInside)

        return button
    }()

    @objc func continueButtonPressed() {
        if let viewController = parent as? FindPlacePageViewController {
            viewController.nextPage()
        }
    }
}

// MARK: - Private methods

private extension CountOfPeopleViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))

        view.addSubview(helloLabel)

        helloLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.9)
            make.centerX.centerY.equalToSuperview()
        }

        view.addSubview(smileLabel)

        smileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(helloLabel.snp.top).offset(-20)
        }

        view.addSubview(companyButton)

        companyButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }

        view.addSubview(pairButton)

        pairButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(companyButton.snp.top).inset(-20)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }
        view.addSubview(singleButton)

        singleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(pairButton.snp.top).inset(-20)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }
    }
}
