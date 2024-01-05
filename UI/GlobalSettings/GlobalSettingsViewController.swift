//
//  GlobalSettingsViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 5.01.24.
//

import UIKit

class GlobalSettingsViewController: UIViewController {
    
    
    // MARK: - Lifecycle
    
    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }
    
    // MARK: - Private constants
    
    private enum UIConstants {
        static let feedbackBigLabelHeight:CGFloat = 30
        static let feedbackSmallLabelHeight:CGFloat = 70
        static let labelsTopOffset:CGFloat = 10
        static let sublabelHeight:CGFloat = 20
        static let segmentedControlHeight:CGFloat = 40
        static let textFieldHeight:CGFloat = 50
        static let sendFeedbackButtonHeight: CGFloat = 50
    }

    // MARK: - Private properties
    
    
    private let titleLabelView: UILabel = {
        let label = UILabel()

        label.text = "Настройки"
        label.font = .systemFont(ofSize: 20, weight: .bold)
        label.textAlignment = .center
        label.textColor = .black

        return label

    }()
    
}
// MARK: - Private methods
private extension GlobalSettingsViewController {
    
    func initialize() {
        view.backgroundColor = .white
        //view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(closeTextFields)))
        
        configNavigation()
    }
    
    
    
    func configNavigation() {
        navigationController?.isNavigationBarHidden = false
        navigationController?.navigationBar.isHidden = false
        navigationController?.navigationBar.tintColor = .black
        navigationItem.leftBarButtonItems = getLeftBarButtonItems()
        navigationController?.navigationBar.barTintColor = .white
        navigationItem.titleView = titleLabelView
    }
    
    func getLeftBarButtonItems() -> [UIBarButtonItem] {
        var items = [UIBarButtonItem]()

        items.append(UIBarButtonItem(image: UIImage(systemName: "chevron.left"), style: .plain, target: self, action: #selector(back)))

        return items
    }

    @objc func back() {
        navigationController?.setViewControllers([navigationController!.viewControllers.first!], animated: true)
        navigationController?.isNavigationBarHidden = true
    }
}
