//
//  OnboardingViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol OnboardingViewModelCoordinatorDelegate: class {
    func goToOnboardingFinished()
    func goToAppSettings()
}

protocol OnboardingViewModelViewDelegate: class {
    func locationPermissionsWereDenied()
}

protocol OnboardingViewModelInterface {
    var viewDelegate: OnboardingViewModelViewDelegate? {get set}

    func handleFinishOnboarding()
    func handlePermissionsTapped()
    func handleGoToAppSettings()

    func getInitialPageViewController() -> UIViewController

    func pageViewControllerCount() -> Int
    func getPageViewController(before viewController: UIViewController) -> UIViewController?
    func getPageViewController(after viewController: UIViewController) -> UIViewController?
}

class OnboardingViewModel: OnboardingViewModelInterface {
    var coordinator: OnboardingViewModelCoordinatorDelegate?
    weak var viewDelegate: OnboardingViewModelViewDelegate?

    var locationPermissionsManager: LocationPermissionsManagerInterface? {
        didSet {
            locationPermissionsManager?.delegate = self
        }
    }

    lazy var pageViewControllers: [UIViewController] = {
        return [
            self.getViewController(identifier: "OnboardingWelcomePageViewController"),
            self.getViewController(identifier: "OnboardingAboutPageViewController"),
            self.getViewController(identifier: "OnboardingPermissionsPageViewController"),
            self.getViewController(identifier: "OnboardingGetStartedPageViewController")
        ]
    }()

    func handleFinishOnboarding() {
        guard locationPermissionsManager!.hasAuthorizedLocationPermissions() else {
            handlePermissionsTapped()
            return
        }

        coordinator?.goToOnboardingFinished()
    }

    func handlePermissionsTapped() {
        locationPermissionsManager?.authorizeLocationPermissions()
    }

    func handleGoToAppSettings() {
        coordinator?.goToAppSettings()
    }

    func getInitialPageViewController() -> UIViewController {
        return pageViewControllers[0]
    }

    func pageViewControllerCount() -> Int {
        return pageViewControllers.count
    }

    func getPageViewController(before viewController: UIViewController) -> UIViewController? {
        let currentIndex = indexForPageViewController(viewController)

        guard !isIndexOutOfRange(currentIndex-1) else {
            return nil
        }

        let previousPageVC = pageViewControllers[currentIndex-1]
        return previousPageVC
    }

    func getPageViewController(after viewController: UIViewController) -> UIViewController? {
        let currentIndex = indexForPageViewController(viewController)

        guard !isIndexOutOfRange(currentIndex+1) else {
            return nil
        }

        let nextPageVC = pageViewControllers[currentIndex+1]
        return nextPageVC
    }
}

private extension OnboardingViewModel {
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

extension OnboardingViewModel: LocationPermissionsManagerDelegate {
    func permissionsGranted() {}

    func permissionsDenied() {
        viewDelegate?.locationPermissionsWereDenied()
    }
}
