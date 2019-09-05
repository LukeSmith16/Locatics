//
//  OnboardingViewController.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class OnboardingViewController: UIPageViewController {
    var onboardingViewModel: OnboardingViewModelInterface? {
        didSet {
            onboardingViewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDSAndDelegate()
        setupPageViewControllers()
    }

    @IBAction func doneTapped(_ sender: Any) {
        onboardingViewModel?.handleFinishOnboarding()
    }

    @IBAction func permissionsTapped(_ sender: Any) {
        onboardingViewModel?.handlePermissionsTapped()
    }
}

private extension OnboardingViewController {
    func setupDSAndDelegate() {
        self.dataSource = self
        self.delegate = self
    }

    func setupPageViewControllers() {
        let initialPageViewController = onboardingViewModel!.getInitialPageViewController()
        self.setViewControllers([initialPageViewController], direction: .forward, animated: true, completion: nil)
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingViewModel!.pageViewControllerCount()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return onboardingViewModel?.getPageViewController(before: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return onboardingViewModel?.getPageViewController(after: viewController)
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {}

extension OnboardingViewController: OnboardingViewModelViewDelegate {
    func locationPermissionsWereDenied() {
        let alertController = AlertController.create(title: "Location Permissions",
                                                     message: "You must allow Locatics to use your location before proceeding",
                                                     actionTitle: "App Settings") { [unowned self] in
                                                     self.onboardingViewModel?.handleGoToAppSettings()
        }

        self.present(alertController, animated: true, completion: nil)
    }
}
