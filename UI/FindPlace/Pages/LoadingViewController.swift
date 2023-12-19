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
        label.text = "Рассматриваем ваши ответы.."
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
        DispatchQueue.main.asyncAfter(deadline: .now() + 1) { [self] in
            taskLabel.text = "Заглядываем в базу мест.."
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [self] in
            taskLabel.text = "Подбираем лучшее место.."
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [self] in
            if let viewController = parent as? FindPlacePageViewController {
                viewController.dismiss(animated: true)
                NotificationCenter.default.post(Notification(name: Notification.Name("findPlace")))
            }
        }
    }
}
