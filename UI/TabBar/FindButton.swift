//
//  FindButton.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import UIKit

final class FindButton: UIButton {
    // MARK: - Initialization

    override init(frame: CGRect) {
        super.init(frame: frame)

        initialization()
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Layout Subviews

    override func layoutSubviews() {
        super.layoutSubviews()

        layer.cornerRadius = frame.width / 2
    }
}

// MARK: - Private methods

private extension FindButton {
    func initialization() {
        setImage(UIImage(systemName: "magnifyingglass"), for: .normal)
        tintColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))

        backgroundColor = UIColor(cgColor: CGColor(red: 251 / 255, green: 211 / 255, blue: 59 / 255, alpha: 1))
    }
}
