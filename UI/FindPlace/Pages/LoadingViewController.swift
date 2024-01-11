//
//  LoadingViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import SnapKit
import UIKit

final class LoadingViewController: UIViewController {
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
        label.text = "Подбираем лучшее место.."
        label.textColor = .white

        return label
    }()
}

private extension LoadingViewController {
    func initialization() {
        view.addSubview(indicator)

        indicator.snp.makeConstraints { make in
            make.center.equalToSuperview()
        }

        view.addSubview(taskLabel)

        taskLabel.snp.makeConstraints { make in
            make.centerX.equalToSuperview()
            make.top.equalTo(indicator.snp.bottom).offset(10)
        }

        createLabels()
    }

    func createLabels() {

        AlgorithmNetworkManager.findPlace { responseEntity  in
            if let place = responseEntity{
                print(place.nameOfPlace)
                UserDefaults.standard.setValue(place.id, forKey: "placeId")
                if let viewController = self.parent as? FindPlacePageViewController {
                    viewController.dismiss(animated: true)
                    NotificationCenter.default.post(Notification(name: Notification.Name("findPlace")))
                } else {
                    print("not a FindPlacePageViewController")
                }
            } else{
                print("algorithm response error")
            }
        }
    }
}
