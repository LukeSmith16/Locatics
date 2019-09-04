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

    lazy var pageViewControllers: [UIViewController] = {
        return [
            self.getViewController(identifier: "OnboardingWelcomePageViewController"),
            self.getViewController(identifier: "OnboardingAboutPageViewController"),
            self.getViewController(identifier: "OnboardingPermissionsPageViewController"),
            self.getViewController(identifier: "OnboardingGetStartedPageViewController")
        ]
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDSAndDelegate()
        setupPageViewControllers()
    }
}

private extension OnboardingViewController {
    func setupDSAndDelegate() {
        self.dataSource = self
        self.delegate = self
    }

    func setupPageViewControllers() {
        self.setViewControllers([pageViewControllers.first!], direction: .forward, animated: true, completion: nil)
    }

    func getViewController(identifier: String) -> UIViewController {
        let onboardingStoryboard = UIStoryboard(name: "OnboardingStoryboard", bundle: Bundle.main)
        let onboardingVCMatchingIdentifier = onboardingStoryboard.instantiateViewController(withIdentifier: identifier)

        return onboardingVCMatchingIdentifier
    }

    func indexForPageViewController(_ viewController: UIViewController) -> Int {
        guard let index = pageViewControllers.firstIndex(of: viewController) else {
            return -2
        }

        return index
    }

    func isIndexOutOfRange(_ index: Int) -> Bool {
        return !pageViewControllers.indices.contains(index)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return pageViewControllers.count
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        let currentIndex = indexForPageViewController(viewController)

        guard !isIndexOutOfRange(currentIndex-1) else {
            return nil
        }

        let previousPageVC = pageViewControllers[currentIndex-1]
        return previousPageVC
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        let currentIndex = indexForPageViewController(viewController)

        guard !isIndexOutOfRange(currentIndex+1) else {
            return nil
        }

        let nextPageVC = pageViewControllers[currentIndex+1]
        return nextPageVC
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {}
