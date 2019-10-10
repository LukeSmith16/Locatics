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
        return OnboardingWelcomePageViewController()
    }

    func pageViewControllerCount() -> Int {
        return 4
    }

    func getPageViewController(before viewController: UIViewController) -> UIViewController? {
        calledGetPageVCBefore = true

        return OnboardingWelcomePageViewController()
    }

    func getPageViewController(after viewController: UIViewController) -> UIViewController? {
        calledGetPageVCAfter = true

        return OnboardingPermissionsPageViewController()
    }
}
