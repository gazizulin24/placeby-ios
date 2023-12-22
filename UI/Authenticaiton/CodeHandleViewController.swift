//
//  CodeHandleViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 15.12.23.
//

import UIKit

final class CodeHandleViewController: UIViewController {
    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialization()
    }

    // MARK: - Private constants

    private let indicator: UIActivityIndicatorView = {
        let indicator = UIActivityIndicatorView()

        indicator.startAnimating()

        indicator.color = .white

        return indicator
    }()

    private let taskLabel: UILabel = {
        let label = UILabel()
        label.font = .systemFont(ofSize: 10)
        label.textAlignment = .center
        label.text = "Обработка.."
        label.textColor = .white

        return label
    }()
}

private extension CodeHandleViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 15 / 255, green: 15 / 255, blue: 16 / 255, alpha: 1))
        view.addSubview(indicator)

        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(taskLabel)

        taskLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(indicator.snp.bottom).offset(10)
        }

        validateCode()
    }

    func validateCode() {
        let phoneNum: String = UserDefaults.standard.string(forKey: "userPhoneNum")!
        let code: String = UserDefaults.standard.string(forKey: "code")!

        print(phoneNum)
        print(code)

        PhoneNumberAuthManager.makeConfirmPhoneNumberRequest(phoneNum: phoneNum, code: code) { responseEntity in

            if let entity = responseEntity {
                print(entity)
                if entity.isCodeValid {
                    if entity.isRegistred! {
                        self.getUserId()
                        UserDefaults.standard.setValue(true, forKey: "isLogged")
                        self.navigationController?.setViewControllers([MainTabBarController()], animated: true)
                    } else {
                        self.navigationController?.setViewControllers([RegistrationViewController()], animated: true)
                    }

                } else {
                    self.navigationController?.setViewControllers([ValidatePhoneNumViewController()], animated: true)
                }
            } else {
                print("ошибка makeConfirmPhoneNumberRequest")
            }
        }
    }

    func getUserId() {
        UserNetworkManager.makeUserIdByPhoneNumRequest(phoneNum: UserDefaults.standard.string(forKey: "userPhoneNum")!) { responseEntity in
            if let response = responseEntity {
                UserDefaults.standard.setValue(response.userId, forKey: "userId")
                UserDefaults.standard.removeObject(forKey: "userPhoneNum")
            } else {
                print("Ошибка makeUserIdByPhoneNumRequest")
            }
        }
    }
}
