//
//  ProfileViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 14.12.23.
//

import Alamofire
import UIKit

final class ProfileViewController: UIViewController {


    override func viewDidLoad() {
        super.viewDidLoad()

        view.backgroundColor = .white

        view.addSubview(label)

        label.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }
        makeRequest()
    }

    let label: UILabel = {
        let label = UILabel()

        label.textAlignment = .center
        label.textColor = .black
        label.numberOfLines = 4
        label.font = .systemFont(ofSize: 15)

        return label
    }()

    func makeRequest() {
        let userId = UserDefaults.standard.integer(forKey: "userId")
        UserNetworkManager.makeGetPersonRequest(id: userId) { responseEntity in
            if let response = responseEntity {
                self.label.text = "Здравствуйте, \(response.name)!"
            } else{
                print("ошибка makeGetPersonRequest")
                
                let user = User(phoneNum: "333496508", name: "Егор", birthday: "2007-09-12", sex: "male")
            }
        }
    }
}
