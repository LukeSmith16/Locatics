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

enum OnboardingStoryboardIdentifier: String {
    case onboardingWelcomePageViewController = "OnboardingWelcomePageViewController"
    case onboardingAboutPageViewController = "OnboardingAboutPageViewController"
    case onboardingPermissionsPageViewController = "OnboardingPermissionsPageViewController"
    case onboardingGetStartedPageViewController = "OnboardingGetStartedPageViewController"
}

class OnboardingViewModel: OnboardingViewModelInterface {
    var coordinator: OnboardingViewModelCoordinatorDelegate?
    weak var viewDelegate: OnboardingViewModelViewDelegate?

    var locationPermissionsManager: LocationPermissionsManagerInterface?

    lazy var pageViewControllers: [UIViewController] = {
        return [
            self.getViewController(identifier: .onboardingWelcomePageViewController),
            self.getViewController(identifier: .onboardingAboutPageViewController),
            self.getViewController(identifier: .onboardingPermissionsPageViewController),
            self.getViewController(identifier: .onboardingGetStartedPageViewController)
        ]
    }()

    // TODO: add check if auth status has not been determined if it aint then 'handlePermissionsTapped()'
    func handleFinishOnboarding() {
        guard locationPermissionsManager!.hasAuthorizedLocationPermissions() else {
            permissionsDenied()
            return
        }

        OnboardingManager.setOnboarding(true)
        coordinator?.goToOnboardingFinished()
    }

    func handlePermissionsTapped() {
        locationPermissionsManager?.delegate = self
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
    func getViewController(identifier: OnboardingStoryboardIdentifier) -> UIViewController {
        let onboardingStoryboard = UIStoryboard.Storyboard.onboarding
        let onboardingVC = onboardingStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)

        return onboardingVC
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
