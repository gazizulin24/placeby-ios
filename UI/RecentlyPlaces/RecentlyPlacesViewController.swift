//
//  RecentlyPlacesViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import UIKit

final class RecentlyPlacesViewController: UIViewController {
    override func viewDidLoad() {
        super.viewDidLoad()

        navigationItem.title = "Недавние"
        navigationController?.navigationBar.prefersLargeTitles = true
    }
}
