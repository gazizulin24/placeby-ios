//
//  LoginWebViewController.swift
//  UpTodo
//
//  Created by Timur Gazizulin on 6.12.23.
//

import SnapKit
import UIKit
import WebKit

class LoginWebViewController: UIViewController {
    // MARK: - Init

    init(page: String) {
        if let url = URL(string: page) {
            webView.load(URLRequest(url: url))
        }
        super.init(nibName: nil, bundle: nil)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()

        initialize()
    }

    // MARK: - Private properties

    private let webView: WKWebView = {
        let webView = WKWebView()

        return webView
    }()
}

// MARK: - Private methods

private extension LoginWebViewController {
    func initialize() {
        view.addSubview(webView)

        webView.snp.makeConstraints { make in
            make.size.equalToSuperview()
        }
    }
}
