//
//  MockOnboardingViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics
class MockOnboardingViewModel: OnboardingViewModelInterface {

    var calledHandleFinishOnboarding = false
    var calledHandlePermissionsTapped = false

    var calledGetPageVCBefore = false
    var calledGetPageVCAfter = false

    weak var viewDelegate: OnboardingViewModelViewDelegate?

    func handleFinishOnboarding() {
        calledHandleFinishOnboarding = true
    }

    func handlePermissionsTapped() {
        calledHandlePermissionsTapped = true
    }

    func handleGoToAppSettings() {}

    func getInitialPageViewController() -> UIViewController {
        return createOnboardingPageVC(with: .onboardingWelcomePageViewController)
    }

    func pageViewControllerCount() -> Int {
        return 4
    }

    func getPageViewController(before viewController: UIViewController) -> UIViewController? {
        calledGetPageVCBefore = true

        let onboardingVC = createOnboardingPageVC(with: .onboardingWelcomePageViewController)
        return onboardingVC
    }

    func getPageViewController(after viewController: UIViewController) -> UIViewController? {
        calledGetPageVCAfter = true

        let onboardingVC = createOnboardingPageVC(with: .onboardingPermissionsPageViewController)
        return onboardingVC
    }
}

private extension MockOnboardingViewModel {
    func createOnboardingPageVC(with identifier: OnboardingStoryboardIdentifier) -> UIViewController {
        let onboardingStoryboard = UIStoryboard.Storyboard.onboarding
        let onboardingVC = onboardingStoryboard.instantiateViewController(withIdentifier: identifier.rawValue)
        _ = onboardingVC.view

        return onboardingVC
    }
}
