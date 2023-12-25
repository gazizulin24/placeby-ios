//
//  RegistrationViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 18.12.23.
//

import SnapKit
import UIKit

final class RegistrationViewController: UIViewController {
    // MARK: - Initialize

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private let segmentedControlItems = ["👨", "👽", "👩"]
    private let sex = ["male", "unowned", "female"]

    private enum UIConstants {
        static let labelFontSize: CGFloat = 25
        static let viewToEmojiLabelInset: CGFloat = 125
        static let textFieldWidth: CGFloat = 330
        static let textFieldHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 250
        static let buttonHeight: CGFloat = 70
        static let viewToRegistrationButtonBottomInset: CGFloat = 50
    }

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Давайте познакомимся"
        label.textColor = .white
        label.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    private let sexLabel: UILabel = {
        let label = UILabel()

        label.text = "Ваш пол:"
        label.textColor = .white
        label.font = .systemFont(ofSize: UIConstants.labelFontSize - 5)
        label.textAlignment = .left
        label.numberOfLines = 1

        return label
    }()

    private let sexView: UIView = {
        let view = UIView()

        return view
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()

        label.text = "🙋‍♂️"
        label.font = .systemFont(ofSize: UIConstants.labelFontSize + 40, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    private lazy var datePickerView: UIDatePicker = {
        let pickerView = UIDatePicker()

        pickerView.datePickerMode = .date
        pickerView.preferredDatePickerStyle = .wheels
        pickerView.minimumDate = Calendar(identifier: .gregorian).date(from: DateComponents(year: 1920, month: 1, day: 1))
        pickerView.maximumDate = Date.now
        return pickerView
    }()

    private lazy var dateTextField: UITextField = {
        let textField = UITextField()

        textField.textAlignment = .center

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: UIConstants.labelFontSize - 5)
        textField.textAlignment = .left
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
        textField.textColor = .white

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5

        let datePickerToolbar = UIToolbar(frame: CGRect(x: 0, y: 0, width: view.frame.width, height: 44))
        let doneButtonDatePicker = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonTappedDatePicker))

        datePickerToolbar.setItems([doneButtonDatePicker], animated: false)

        textField.inputView = datePickerView
        textField.inputAccessoryView = datePickerToolbar

        return textField
    }()

    private let dateLabel: UILabel = {
        let label = UILabel()

        label.text = "Ваша дата рождения:"
        label.textColor = .white
        label.font = .systemFont(ofSize: UIConstants.labelFontSize - 5)
        label.textAlignment = .left
        label.numberOfLines = 1

        return label
    }()

    private let dateView: UIView = {
        let view = UIView()

        return view
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()

        textField.delegate = self

        textField.attributedPlaceholder = NSAttributedString(string: "Ваше имя", attributes: [.foregroundColor: UIColor.gray])

        textField.textAlignment = .center

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: UIConstants.labelFontSize - 5)
        textField.textAlignment = .left
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
        textField.textColor = .white

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5

        return textField
    }()

    private lazy var sexSegmentedControl: UISegmentedControl = {
        let segmentedControl = UISegmentedControl(items: segmentedControlItems)

        segmentedControl.selectedSegmentIndex = 1

        segmentedControl.selectedSegmentTintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 0.3))

        segmentedControl.addTarget(self, action: #selector(selectSex(_:)), for: .valueChanged)

        return segmentedControl
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        button.setTitle("Подтвердить", for: .normal)

        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(loginButtonPressed), for: .touchUpInside)
        return button
    }()
}

// MARK: - Private methods

private extension RegistrationViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 15 / 255, green: 15 / 255, blue: 16 / 255, alpha: 1))

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(resignTextFields)))

        view.addSubview(emojiLabel)

        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalToSuperview().inset(UIConstants.viewToEmojiLabelInset)
        }

        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(emojiLabel.snp.bottom).offset(20)
        }

        view.addSubview(usernameTextField)

        usernameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(UIConstants.textFieldHeight)
            make.top.equalTo(titleLabel.snp.bottom).offset(20)
        }

        view.addSubview(sexView)

        sexView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(30)
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(30)
        }

        sexView.addSubview(sexLabel)

        sexLabel.snp.makeConstraints { make in
            make.centerY.leading.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.40)
        }

        sexView.addSubview(sexSegmentedControl)

        sexSegmentedControl.snp.makeConstraints { make in
            make.centerY.trailing.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.65)
        }

        view.addSubview(dateView)

        dateView.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(sexView.snp.bottom).offset(30)
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(30)
        }

        dateView.addSubview(dateLabel)

        dateLabel.snp.makeConstraints { make in
            make.centerY.leading.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.65)
        }

        dateView.addSubview(dateTextField)

        dateTextField.snp.makeConstraints { make in
            make.centerY.trailing.height.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.38)
            make.height.equalToSuperview()
        }

        view.addSubview(loginButton)

        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalToSuperview().inset(UIConstants.viewToRegistrationButtonBottomInset)
            make.width.equalTo(UIConstants.buttonWidth)
            make.height.equalTo(UIConstants.buttonHeight)
        }
    }

    @objc func loginButtonPressed() {
        if usernameTextField.text?.count == 0 {
            animateUsernameError()
        } else {
            if dateTextField.text?.count == 0 {
                animateDateError()
            } else {
                let user = User(phoneNum: UserDefaults.standard.string(forKey: "userPhoneNum")!, name: usernameTextField.text!, birthday: dateTextField.text!, sex: sex[sexSegmentedControl.selectedSegmentIndex])

                RegistrationAuthManager.makeRegistrationRequest(user: user) { responseEntity in
                    if let response = responseEntity {
                        if response.userId == -1 {
                            print("ошибка makeRegistrationRequest")
                            self.animateDateError()
                            self.animateUsernameError()
                        } else {
                            UserDefaults.standard.setValue(response.userId, forKey: "userId")
                            UserDefaults.standard.setValue(true, forKey: "isLogged")
                            UserDefaults.standard.removeObject(forKey: "userPhoneNum")

                            self.navigationController?.setViewControllers([MainTabBarController()], animated: true)
                        }
                    } else {
                        print("Ошибка")
                    }
                }
            }
        }
    }

    @objc func resignTextFields() {
        usernameTextField.resignFirstResponder()
    }

    @objc func selectSex(_ segmentedControl: UISegmentedControl) {
        print(segmentedControl.selectedSegmentIndex)
    }

    @objc func validatePhoneNum() {
        if usernameTextField.text!.count != 10 {
            animateUsernameError()

        } else {
            print("succeed")
        }
    }

    func animateUsernameError() {
        usernameTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        UIView.animate(withDuration: 1) {
            self.usernameTextField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        }
    }

    func animateDateError() {
        dateTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        UIView.animate(withDuration: 1) {
            self.dateTextField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        }
    }

    @objc func doneButtonTappedDatePicker() {
        dateTextField.text = String(datePickerView.date.description.prefix(10))
        dateTextField.resignFirstResponder()
    }
}

// MARK: - UITextFieldDelegate

extension RegistrationViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        if string != "" {
            return text.count <= 20
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        default:
            textField.resignFirstResponder()
        }

        return false
    }
}
