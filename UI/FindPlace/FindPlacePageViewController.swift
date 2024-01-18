//
//  FindPlacePageViewController.swift
//  placeby
//
//  Created by Timur Gazizulin on 12.12.23.
//

import UIKit

final class FindPlacePageViewController: UIPageViewController {
    // MARK: - Initialization

    override init(transitionStyle _: UIPageViewController.TransitionStyle, navigationOrientation _: UIPageViewController.NavigationOrientation, options _: [UIPageViewController.OptionsKey: Any]? = nil) {
        super.init(transitionStyle: .scroll, navigationOrientation: .horizontal)

        setViewControllers([pages.first!], direction: .forward, animated: true)
    }

    @available(*, unavailable)
    required init?(coder _: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    // MARK: - Lifecycle

    override func viewDidLoad() {
        super.viewDidLoad()
        initialization()
    }

    // MARK: - Public methods

    func nextPage() {
        print("next")

        if let index = pages.firstIndex(of: viewControllers!.first!) {
            if index < pages.count - 1 {
                setViewControllers([pages[index + 1]], direction: .forward, animated: true, completion: nil)
            } else {
                dismiss(animated: true)
            }
        }
    }

    // MARK: - Private constants

    private let pages: [UIViewController] = [FindPlaceHelloViewController(),
                                             IsFamilyViewController(),
                                             CountOfPeopleViewController(),
                                             IsEntertainmentViewController(),
                                             DirectionViewController(),
                                             LoadingViewController()]

    // MARK: - Private properties
}

// MARK: - Private methods

private extension FindPlacePageViewController {
    func initialization() {
        view.backgroundColor = UIColor(cgColor: CGColor(red: 54 / 255, green: 54 / 255, blue: 54 / 255, alpha: 1))

        configurePageControl()
    }

    func configurePageControl() {
        let pageControl = UIPageControl.appearance()

        pageControl.pageIndicatorTintColor = view.backgroundColor
        pageControl.pageIndicatorTintColor = UIColor(cgColor: CGColor(red: 100 / 225, green: 100 / 225, blue: 100 / 225, alpha: 1))
        pageControl.currentPageIndicatorTintColor = .white

        // hidden
        pageControl.isHidden = false
    }
}
