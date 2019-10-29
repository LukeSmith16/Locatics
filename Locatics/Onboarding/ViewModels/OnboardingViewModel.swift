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

    func goToNextPage(nextVC: UIViewController)
    func goToLastPage(lastVC: UIViewController)
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

    var onboardingNavigationViewModels: [OnboardingNavigationViewModelInterface] = []

    var locationPermissionsManager: LocationPermissionsManagerInterface?

    lazy var pageViewControllers: [UIViewController] = {
        return [
            self.getViewController(identifier: .onboardingWelcomePageViewController),
            self.getViewController(identifier: .onboardingAboutPageViewController),
            self.getViewController(identifier: .onboardingPermissionsPageViewController),
            self.getViewController(identifier: .onboardingGetStartedPageViewController)
        ]
    }()

    func handleFinishOnboarding() {
        guard locationPermissionsManager!.hasAuthorizedLocationPermissions() else {
            handleAuthorisationError()
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
        injectViewModelInto(viewController: onboardingVC, with: identifier)

        return onboardingVC
    }

    func injectViewModelInto(viewController: UIViewController,
                             with identifier: OnboardingStoryboardIdentifier) {
        switch identifier {
        case .onboardingWelcomePageViewController:
            let welcomePageVC = viewController as? OnboardingWelcomePageViewController
            welcomePageVC?.onboardingNavigationViewModel = onboardingNavigationViewModels[0]
        case .onboardingAboutPageViewController:
            let aboutPageVC = viewController as? OnboardingAboutPageViewController
            aboutPageVC?.onboardingNavigationViewModel = onboardingNavigationViewModels[1]
        case .onboardingPermissionsPageViewController:
            let permissionsPageVC = viewController as? OnboardingPermissionsPageViewController
            permissionsPageVC?.onboardingNavigationViewModel = onboardingNavigationViewModels[2]
        case .onboardingGetStartedPageViewController:
            let getStartedPageVC = viewController as? OnboardingGetStartedPageViewController
            getStartedPageVC?.onboardingNavigationViewModel = onboardingNavigationViewModels[3]
        }
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

    func handleAuthorisationError() {
        if locationPermissionsManager!.authorizationStatus() == .notDetermined {
            handlePermissionsTapped()
        } else {
            permissionsDenied()
        }
    }
}

extension OnboardingViewModel: OnboardingNavigationViewModelViewDelegate {
    func nextWasTapped(atIndex: Int) {
        guard atIndex < (pageViewControllers.count - 1) else { return }
        let nextViewController = pageViewControllers[atIndex+1]
        viewDelegate?.goToNextPage(nextVC: nextViewController)
    }

    func skipWasTapped() {
        viewDelegate?.goToLastPage(lastVC: pageViewControllers.last!)
    }
}

extension OnboardingViewModel: LocationPermissionsManagerDelegate {
    func permissionsGranted() {}

    func permissionsDenied() {
        viewDelegate?.locationPermissionsWereDenied()
    }
}
