//
//  IsFamilyViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 18.01.24.
//

import UIKit

class IsFamilyViewController: UIViewController {
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

        label.text = "👨‍👩‍👦"
        label.textAlignment = .center
        label.font = .systemFont(ofSize: UIConstants.smileLabelFontSize)
        return label
    }()

    private let helloLabel: UILabel = {
        let label = UILabel()

        label.text = "На прогулку пойдете семьей?"
        label.numberOfLines = 2
        label.font = .systemFont(ofSize: UIConstants.helloLabelFontSize, weight: .bold)
        label.textColor = .white
        label.textAlignment = .center
        return label
    }()

    private lazy var yesButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Да", for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(yesButtonPressed), for: .touchUpInside)

        return button
    }()

    private lazy var noButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Нет", for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(noButtonPressed), for: .touchUpInside)

        return button
    }()

}

// MARK: - Private methods

private extension IsFamilyViewController {
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

        view.addSubview(noButton)

        noButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(50)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }

        view.addSubview(yesButton)

        yesButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(noButton.snp.top).inset(-20)
            make.width.equalTo(200)
            make.height.equalTo(70)
        }
    }
    
    
    @objc func yesButtonPressed(){
        UserDefaults.standard.setValue(true, forKey: "isFamily")
        continueButtonPressed()
    }
    
    @objc func noButtonPressed(){
        UserDefaults.standard.setValue(false, forKey: "isFamily")
        continueButtonPressed()
    }
    
    func continueButtonPressed() {
        if let viewController = parent as? FindPlacePageViewController {
            viewController.nextPage()
        }
    }
}
