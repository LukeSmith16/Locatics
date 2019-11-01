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

    var calledNextWasTapped = false
    var calledSkipWasTapped = false

    var calledHandleFinishOnboarding = false
    var calledHandlePermissionsTapped = false

    var calledGetPageVCBefore = false
    var calledGetPageVCAfter = false

    var calledIndexOf = false

    weak var viewDelegate: OnboardingViewModelViewDelegate?

    var nextWasTappedPassedValue: Int?
    func nextWasTapped(for index: Int) {
        calledNextWasTapped = true

        nextWasTappedPassedValue = index
    }

    func skipWasTapped() {
        calledSkipWasTapped = true
    }

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

    var indexOfPassedValue: UIViewController?
    func indexOf(viewController: UIViewController) -> Int? {
        calledIndexOf = true

        indexOfPassedValue = viewController

        return 0
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
