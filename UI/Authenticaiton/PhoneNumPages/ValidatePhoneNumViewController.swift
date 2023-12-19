//
//  ValidatePhoneNumViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 15.12.23.
//

import UIKit

final class ValidatePhoneNumViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private var userPhoneNum: String = "+375\(UserDefaults.standard.string(forKey: "userPhoneNum") ?? "123456789")"

    private enum UIConstants {
        static let labelFontSize: CGFloat = 20
        static let titleToSubtitleLabelOffset: CGFloat = -20
        static let textFieldToLabelOffset: CGFloat = -10
        static let textFieldWidth: CGFloat = 350
        static let textFieldHeight: CGFloat = 50
        static let buttonWidth: CGFloat = 330
        static let titleLabelWidth: CGFloat = 350
        static let titleLabelHeight: CGFloat = 100
        static let buttonHeight: CGFloat = 50
        static let viewToUsernameTextFieldInset: CGFloat = 230
        static let usernameToPasswordTextFieldOffset: CGFloat = 65
        static let passwordTextFieldToLoginButtonOffset: CGFloat = 60
        static let orLabelOffset: CGFloat = 60
        static let anotherLoginButtonsOffset: CGFloat = 20
    }

    // MARK: - Private properties

    private lazy var titleLabel: UILabel = {
        let label = UILabel()

        label.font = .systemFont(ofSize: UIConstants.labelFontSize)
        label.textColor = .white
        let text = "Введите 6-ти значный код подтверждения отправленный на номер\n\(userPhoneNum)"
        let range = (text as NSString).range(of: "\(userPhoneNum)")
        let attributedTitle = NSMutableAttributedString(string: text)

        attributedTitle.addAttribute(.font, value: UIFont.systemFont(ofSize: UIConstants.labelFontSize, weight: .bold), range: range)

        label.adjustsFontSizeToFitWidth = true
        label.attributedText = attributedTitle
        label.textAlignment = .center
        label.numberOfLines = 3

        return label
    }()

    private let emojiLabel: UILabel = {
        let label = UILabel()

        label.text = "💬"
        label.font = .systemFont(ofSize: UIConstants.labelFontSize + 40, weight: .bold)
        label.textAlignment = .center
        label.numberOfLines = 1

        return label
    }()

    private lazy var verifidationCodeDigitTextFields: [UITextField] = {
        var textFields = [UITextField]()

        for i in 0 ... 5 {
            let textField = UITextField()

            textField.delegate = self

            textField.text = " "

            textField.keyboardType = .numberPad

            textField.font = .systemFont(ofSize: 20)
            textField.textAlignment = .center
            textField.backgroundColor = UIColor(cgColor: CGColor(red: 29 / 255, green: 29 / 255, blue: 29 / 255, alpha: 1))
            textField.textColor = .white

            textField.layer.borderColor = CGColor(red: 151 / 255, green: 151 / 255, blue: 151 / 255, alpha: 1)
            textField.layer.borderWidth = 1
            textField.layer.cornerRadius = 5
            textFields.append(textField)
        }

        print(textFields)

        return textFields
    }()

    private let digitTextFieldsView: UIView = {
        let view = UIView()

        return view
    }()
}

// MARK: - Private methods

private extension ValidatePhoneNumViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 15 / 255, green: 15 / 255, blue: 16 / 255, alpha: 1))

        setupNotifications()

        view.addSubview(digitTextFieldsView)

        digitTextFieldsView.snp.makeConstraints { make in
            make.centerX.centerY.equalToSuperview()
            make.width.equalTo(UIConstants.textFieldWidth)
            make.height.equalTo(UIConstants.textFieldHeight)
        }

        drawDegitTextFields(view: digitTextFieldsView, textFields: verifidationCodeDigitTextFields)

        view.addSubview(titleLabel)

        titleLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(digitTextFieldsView.snp.top).offset(UIConstants.titleToSubtitleLabelOffset)
            make.width.equalTo(UIConstants.titleLabelWidth)
            make.height.equalTo(UIConstants.titleLabelHeight)
        }

        view.addSubview(emojiLabel)

        emojiLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.bottom.equalTo(titleLabel.snp.top).offset(UIConstants.titleToSubtitleLabelOffset)
        }

        verifidationCodeDigitTextFields.first!.becomeFirstResponder()
    }

    func drawDegitTextFields(view: UIView, textFields: [UITextField]) {
        if textFields.isEmpty { return }

        for (i, textField) in textFields.enumerated() {
            view.addSubview(textField)

            print(CGFloat(1 / textFields.count))

            if i != 0 {
                textField.snp.makeConstraints { make in
                    make.centerY.height.equalToSuperview()
                    make.leading.equalTo(textFields[i - 1].snp.trailing).offset(10)
                    make.width.equalTo(view.snp.height)
                }
            } else {
                textField.snp.makeConstraints { make in
                    make.centerY.height.leading.equalToSuperview()
                    make.width.equalTo(view.snp.height)
                }
            }
        }
    }

    func setupNotifications() {
        // NotificationCenter.default.addObserver(self, selector: #selector(textFieldTextDidChange), name: UITextField.textDidChangeNotification, object: nil)
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

    func saveCode() {
        var code = ""

        for textField in verifidationCodeDigitTextFields {
            code += textField.text ?? ""
        }

        UserDefaults.standard.setValue(code, forKey: "code")
    }
}

// MARK: - UITextFieldDelegate

extension ValidatePhoneNumViewController: UITextFieldDelegate {
    func textFieldDidChangeSelection(_ textField: UITextField) {
        if textField.text?.isEmpty ?? true {
            print("Удален символ из пустого поля")

            if let index = verifidationCodeDigitTextFields.firstIndex(of: textField) {
                if index > 0 {
                    verifidationCodeDigitTextFields[index].text = " "
                    verifidationCodeDigitTextFields[index - 1].becomeFirstResponder()
                }
            }
        }
    }

    func textField(_ textField: UITextField, shouldChangeCharactersIn _: NSRange, replacementString string: String) -> Bool {
        print("'\(string)'")
        if let index = verifidationCodeDigitTextFields.firstIndex(of: textField) {
            if string != "" {
                if index < verifidationCodeDigitTextFields.count - 1 {
                    verifidationCodeDigitTextFields[index].text = string
                    verifidationCodeDigitTextFields[index + 1].becomeFirstResponder()
                } else {
                    verifidationCodeDigitTextFields[index].text = string

                    saveCode()
                    navigationController?.setViewControllers([CodeHandleViewController()], animated: true)
                }
            } else {
                return true
            }
        }

        return false
    }

    func textFieldShouldClear(_: UITextField) -> Bool {
        // Выполняйте нужные действия при нажатии на кнопку очистки
        print("Нажата кнопка очистки")

        // Возвращайте true, чтобы стандартное поведение очистки было выполнено
        return true
    }
}
