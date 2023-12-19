//
//  LoginViewController.swift
//  UpTodo
//
//  Created by Timur Gazizulin on 6.12.23.
//

import SnapKit
import UIKit

class LoginViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private enum UIConstants {
        static let labelsFontSize: CGFloat = 16
        static let textFieldToLabelOffset: CGFloat = -10
        static let textFieldWidth: CGFloat = 330
        static let textFieldHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 330
        static let buttonHeight: CGFloat = 50
        static let viewToUsernameTextFieldInset: CGFloat = 230
        static let usernameToPasswordTextFieldOffset: CGFloat = 65
        static let passwordTextFieldToLoginButtonOffset: CGFloat = 60
        static let orLabelOffset: CGFloat = 60
        static let anotherLoginButtonsOffset: CGFloat = 20
    }

    // MARK: - Private properties

    private let usernameLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.labelsFontSize)
        label.textAlignment = .left
        label.textColor = .white
        label.text = "Username"
        return label
    }()

    private lazy var usernameTextField: UITextField = {
        let textField = UITextField()

        textField.delegate = self

        textField.attributedPlaceholder = NSAttributedString(string: "Enter your username", attributes: [.foregroundColor: UIColor.gray])

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.font = .systemFont(ofSize: UIConstants.labelsFontSize)
        textField.textAlignment = .left
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
        textField.textColor = .white

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5

        return textField
    }()

    private let passwordLabel: UILabel = {
        let label = UILabel()

        label.text = "Password"
        label.font = .systemFont(ofSize: UIConstants.labelsFontSize)
        label.textAlignment = .left
        label.textColor = .white

        return label
    }()

    private lazy var passwordTextField: UITextField = {
        let textField = UITextField()

        textField.delegate = self

        textField.attributedPlaceholder = NSAttributedString(string: "* * * * * * * * * * *", attributes: [.foregroundColor: UIColor.gray])

        textField.leftView = UIView(frame: CGRect(x: 0, y: 0, width: 10, height: 1))
        textField.leftViewMode = .always

        textField.textColor = .white
        textField.font = .systemFont(ofSize: UIConstants.labelsFontSize)
        textField.textAlignment = .left
        textField.backgroundColor = UIColor(cgColor: CGColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
        textField.isSecureTextEntry = true

        textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
        textField.layer.borderWidth = 1
        textField.layer.cornerRadius = 5

        return textField
    }()

    private lazy var loginButton: UIButton = {
        let button = UIButton()

        button.configuration = .filled()
        button.setTitle("Login", for: .normal)
        button.setTitleColor(.white, for: .normal)
        button.tintColor = UIColor(cgColor: CGColor(red: 136 / 255, green: 117 / 255, blue: 255 / 17, alpha: 1))

        button.isEnabled = false

        button.addTarget(self, action: #selector(loginAction), for: .touchUpInside)

        return button
    }()

    private let orLabel: UILabel = {
        let label = UILabel()

        label.text = "or"
        label.textColor = .darkGray
        label.textAlignment = .center

        return label
    }()

    private lazy var loginWithGoogleButton: UIButton = {
        let button = UIButton()

        button.configuration = .plain()

        button.configuration?.title = "Login with Google"

        button.configuration?.image = UIImage(named: "GoogleLogo")
        button.configuration?.imagePadding = 10
        button.configuration?.baseForegroundColor = .white
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        button.layer.borderColor = CGColor(red: 136 / 255, green: 117 / 255, blue: 255 / 255, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(loginWithGoogle), for: .touchUpInside)

        return button
    }()

    private lazy var loginWithAppleButton: UIButton = {
        let button = UIButton()

        button.configuration = .plain()

        button.configuration?.title = "Login with Apple"

        button.configuration?.image = UIImage(systemName: "applelogo")?.withTintColor(.white, renderingMode: .alwaysOriginal)
        button.configuration?.imagePadding = 10
        button.configuration?.baseForegroundColor = .white
        button.configuration?.contentInsets = NSDirectionalEdgeInsets(top: 0, leading: 0, bottom: 0, trailing: 0)

        button.layer.borderColor = CGColor(red: 136 / 255, green: 117 / 255, blue: 255 / 255, alpha: 1)
        button.layer.borderWidth = 1
        button.layer.cornerRadius = 5

        button.addTarget(self, action: #selector(loginWithApple), for: .touchUpInside)

        return button
    }()

    private lazy var registrationOfferButton: UIButton = {
        let button = UIButton()

        let text = "Don’t have an account? Register"
        let range = (text as NSString).range(of: "Register")
        let attributedTitle = NSMutableAttributedString(string: text)

        attributedTitle.addAttribute(.foregroundColor, value: UIColor.white, range: range)

        button.setTitleColor(.gray, for: .normal)
        button.setAttributedTitle(attributedTitle, for: .normal)

        button.addTarget(self, action: #selector(openRegistrationPage), for: .touchUpInside)
        return button
    }()
}

// MARK: - Private methods

private extension LoginViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 15 / 255, green: 15 / 255, blue: 16 / 255, alpha: 1))

        setupNavigation()

        setupNotifications()

        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(hideKeyboard)))

        view.addSubview(usernameTextField)

        usernameTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(UIConstants.viewToUsernameTextFieldInset)
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(UIConstants.textFieldHeight)
        }

        view.addSubview(usernameLabel)

        usernameLabel.snp.makeConstraints { make in
            make.leading.equalTo(usernameTextField.snp.leading)
            make.bottom.equalTo(usernameTextField.snp.top).offset(UIConstants.textFieldToLabelOffset)
        }

        view.addSubview(passwordTextField)

        passwordTextField.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(usernameTextField.snp.bottom).offset(UIConstants.usernameToPasswordTextFieldOffset)
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(UIConstants.textFieldHeight)
        }

        view.addSubview(passwordLabel)

        passwordLabel.snp.makeConstraints { make in
            make.leading.equalTo(passwordTextField.snp.leading)
            make.bottom.equalTo(passwordTextField.snp.top).offset(UIConstants.textFieldToLabelOffset)
        }

        view.addSubview(loginButton)

        loginButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(passwordTextField.snp.bottom).offset(UIConstants.passwordTextFieldToLoginButtonOffset)
            make.height.equalTo(UIConstants.buttonHeight)
            make.width.equalTo(UIConstants.buttonWidth)
        }

        view.addSubview(registrationOfferButton)

        registrationOfferButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(view.snp.bottomMargin)
        }

        view.addSubview(loginWithAppleButton)

        loginWithAppleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(registrationOfferButton.snp.top).offset(-(UIConstants.anotherLoginButtonsOffset * 2))
            make.width.equalTo(UIConstants.buttonWidth)
            make.height.equalTo(UIConstants.buttonHeight)
        }

        view.addSubview(loginWithGoogleButton)

        loginWithGoogleButton.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginWithAppleButton.snp.top).offset(-UIConstants.anotherLoginButtonsOffset)
            make.width.equalTo(UIConstants.buttonWidth)
            make.height.equalTo(UIConstants.buttonHeight)
        }

        view.addSubview(orLabel)

        orLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(loginWithGoogleButton.snp.top).offset(-UIConstants.anotherLoginButtonsOffset)
        }
    }

    @objc func openRegistrationPage() {
        navigationController?.pushViewController(RegistrationViewController(), animated: true)
    }

    @objc func loginAction() {
        print("Username: \(usernameTextField.text ?? "nil")")
        print("Password: \(passwordTextField.text ?? "nil")")

        navigationController?.setViewControllers([MainTabBarController()], animated: true)
    }

    @objc func loginWithGoogle() {
        present(LoginWebViewController(page: "https://google.com"), animated: true)
    }

    @objc func loginWithApple() {
        present(LoginWebViewController(page: "https://apple.com"), animated: true)
    }

    @objc func hideKeyboard() {
        usernameTextField.resignFirstResponder()
        passwordTextField.resignFirstResponder()
    }

    func setupNotifications() {
        NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: UITextField.textDidChangeNotification, object: nil)
    }

    @objc func textFieldTextDidChange() {
        if !usernameTextField.text!.isEmpty, passwordTextField.text!.count > 7 {
            loginButton.isEnabled = true
        } else {
            loginButton.isEnabled = false
        }
    }

    func setupNavigation() {
        title = "Login"
        navigationController?.navigationBar.prefersLargeTitles = true
        navigationController?.navigationBar.largeTitleTextAttributes = [NSAttributedString.Key.foregroundColor: UIColor.white]
        navigationItem.hidesBackButton = true

        navigationItem.leftBarButtonItems = getLeftBarButtonItems()
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
}

// MARK: - UITextFieldDelegate

extension LoginViewController: UITextFieldDelegate {
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        switch textField {
        case textField where textField == usernameTextField:
            textField.resignFirstResponder()
            passwordTextField.becomeFirstResponder()
        default:
            textField.resignFirstResponder()
        }

        return false
    }
}
