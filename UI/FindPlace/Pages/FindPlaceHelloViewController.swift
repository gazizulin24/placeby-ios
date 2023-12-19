//
//  FindPlaceHelloViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import SnapKit
import UIKit

final class FindPlaceHelloViewController: UIViewController {
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

        label.text = "👀"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIConstants.smileLabelFontSize)
        return label
    }()

    private let helloLabel: UILabel = {
        let label = UILabel()

        label.text = "Давайте найдем место для прогулки которое будет Вам по душе!"
        label.numberOfLines = 3
        label.font = .systemFont(ofSize: UIConstants.helloLabelFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var continueButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Продолжить", for: .normal)
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

private extension FindPlaceHelloViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))

        view.addSubview(helloLabel)

        helloLabel.snp.makeConstraints { make in
            make.width.equalToSuperview().multipliedBy(0.7)
            make.centerX.centerY.equalToSuperview()
        }

        view.addSubview(smileLabel)

        smileLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(helloLabel.snp.top).offset(-20)
        }

        view.addSubview(continueButton)

        continueButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }
    }
}
