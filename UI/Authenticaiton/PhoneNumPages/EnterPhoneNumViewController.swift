//
//  EnterPhoneNumViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 15.12.23.
//

import UIKit

final class EnterPhoneNumViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let labelFontSize: CGFloat = 25
        static let titleToSubtitleLabelOffset: CGFloat = -20
        static let textFieldToLabelOffset: CGFloat = -10
        static let textFieldWidth: CGFloat = 330
        static let textFieldHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 330
        static let titleLabelWidth: CGFloat = 350
        static let titleLabelHeight: CGFloat = 40
        static let buttonHeight: CGFloat = 50
        static let viewToUsernameTextFieldInset: CGFloat = 230
        static let usernameToPasswordTextFieldOffset: CGFloat = 65
        static let passwordTextFieldToLoginButtonOffset: CGFloat = 60
        static let orLabelOffset: CGFloat = 60
        static let anotherLoginButtonsOffset: CGFloat = 20
    }

    // MARK: - Private properties

    private let titleLabel: UILabel = {
        let label = UILabel()

        label.text = "Введите номер телефона"
        label.textColor = .white
        label.font = .systemFont(ofSize: UIConstants.labelFontSize, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()

        label.text = "☎️"
        label.font = .systemFont(ofSize: UIConstants.labelFontSize + 40, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    private lazy var phoneNumberTextField: UITextField = {
        let textField = UITextField()

        textField.delegate = self

        textField.attributedPlaceholder = NSAttributedString(string: "(12) 345 678 90", attributes: [.foregroundColor: UIColor.gray])

        textField.textAlignment = .center

        textField.keyboardType = .numberPad

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

    private lazy var phoneRegionTextField: UITextField = {
        let textField = UITextField()

        textField.isUserInteractionEnabled = false

        textField.attributedPlaceholder = NSAttributedString(string: "🇧🇾 +375", attributes: [.foregroundColor: UIColor.white])

        textField.textAlignment = .center

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: UIConstants.labelFontSize - 5)
        textField.textAlignment = .left
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5

        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton(configuration: .tinted())

        // button.setTitle("Ввести Номер", for: .normal)
        button.setImage(UIImage(systemName: "checkmark"), for: .normal)

        button.tintColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
        button.addTarget(self, action: #selector(validatePhoneNum), for: .touchUpInside)
        return button
    }()

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.startAnimating()

        indicator.color = .white

        indicator.isHidden = true
        return indicator
    }()

    private let phoneNumberTextFieldsView: UIView = {
        let view = UIView()

        return view
    }()
}

// MARK: - Private methods

private extension EnterPhoneNumViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 15 / 255, green: 15 / 255, blue: 16 / 255, alpha: 1))

        setupNotifications()

        phoneNumberTextField.becomeFirstResponder()

        view.addSubview(phoneNumberTextFieldsView)

        phoneNumberTextFieldsView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(UIConstants.textFieldHeight)
        }

        phoneNumberTextFieldsView.addSubview(phoneRegionTextField)

        phoneRegionTextField.snp.makeConstraints { make in
            make.centerY.height.leading.equalToSuperview()
            make.width.equalToSuperview().multipliedBy(0.30)
        }

        phoneNumberTextFieldsView.addSubview(phoneNumberTextField)

        phoneNumberTextField.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.leading.equalTo(phoneRegionTextField.snp.trailing).offset(5)
            make.width.equalToSuperview().multipliedBy(0.50)
        }

        phoneNumberTextFieldsView.addSubview(loginButton)

        loginButton.snp.makeConstraints { make in
            make.centerY.height.equalToSuperview()
            make.leading.equalTo(phoneNumberTextField.snp.trailing).offset(5)
            make.width.equalToSuperview().multipliedBy(0.18)
        }

        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(phoneNumberTextFieldsView.snp.top).offset(UIConstants.titleToSubtitleLabelOffset)
            make.width.equalTo(UIConstants.titleLabelWidth)
            make.height.equalTo(UIConstants.titleLabelHeight)
        }

        view.addSubview(emojiLabel)

        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(UIConstants.titleToSubtitleLabelOffset)
        }

        view.addSubview(indicator)

        indicator.snp.makeConstraints { make in
            make.center.equalTo(loginButton)
        }
    }

    @objc func loginAction() {
        print("Username: \(phoneNumberTextField.text ?? "nil")")

        navigationController?.setViewControllers([MainTabBarController()], animated: true)
    }

    @objc func hideKeyboard() {
        phoneNumberTextField.resignFirstResponder()
    }

    func setupNotifications() {
        // NotificationCenter.default.addObserver(self, selector: #selector(animatePhoneError), name: Notification.Name("phoneError"), object: nil)
    }

    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        let chevronItem = UIBarButtonItem(image: UIImage(systemName: "chevron.left")?.withTintColor(.white, renderingMode: .alwaysOriginal), style: .plain, target: self, action: #selector(backButtonPressed))

        items.append(chevronItem)
        return items
    }

    @objc func backButtonPressed() {
        if let viewController = navigationController?.viewControllers[1] {
            navigationController?.popToViewController(viewController, animated: true)
        } else {
            navigationController?.popViewController(animated: true)
        }
    }

    func animatePhoneError() {
        phoneNumberTextField.layer.borderColor = CGColor(red: 1, green: 0, blue: 0, alpha: 1)
        UIView.animate(withDuration: 1) {
            self.phoneNumberTextField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        }
    }

    func toggleLoginButton() {
        loginButton.isHidden.toggle()
        indicator.isHidden.toggle()
    }

    func toggleLoginButtonWithError() {
        loginButton.isHidden.toggle()
        indicator.isHidden.toggle()
        animatePhoneError()
    }

    @objc func validatePhoneNum() {
        if phoneNumberTextField.text!.count != 9 {
            animatePhoneError()

        } else {
            UserDefaults.standard.setValue(phoneNumberTextField.text!, forKey: "userPhoneNum")

            toggleLoginButton()

            PhoneNumberAuthManager.makeSendPhoneNumberRequest(phoneNum: phoneNumberTextField.text!) { responseEntity in
                if let entity = responseEntity {
                    if entity.status == true {
                        self.navigationController?.pushViewController(ValidatePhoneNumViewController(), animated: true)
                    } else {
                        self.toggleLoginButtonWithError()
                    }
                } else {
                    print("Ошибка makeSendPhoneNumberRequest")
                    self.toggleLoginButtonWithError()
                }
            }
        }
    }
}

// MARK: - UITextFieldDelegate

extension EnterPhoneNumViewController: UITextFieldDelegate {
    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        guard let text = textField.text else { return true }

        if string != "" {
            return text.count <= 8
        }

        return true
    }

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField where textField == phoneNumberTextField:
            validatePhoneNum()
        default:
            textField.resignFirstResponder()
        }

        return false
    }
}
