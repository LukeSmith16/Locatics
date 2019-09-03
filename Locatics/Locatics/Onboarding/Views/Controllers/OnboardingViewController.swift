//
//  OnboardingViewController.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    var onboardingViewModel: OnboardingViewModelInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDSAndDelegate()
    }
}

private extension OnboardingViewController {
    func setupDSAndDelegate() {
        self.dataSource = self
        self.delegate = self
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return UIViewController()
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {}
