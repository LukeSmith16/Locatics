//
//  MockOnboardingViewModelViewDelegate.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

@testable import Locatics
class MockOnboardingViewModelViewDelegate: OnboardingViewModelViewDelegate {
    var calledLocationPermissionsWereDenied = false

    var calledGoToNextPage = false
    var calledGoToLastPage = false

    var goToNextPagePassedVC: UIViewController?
    var goToLastPageVC: UIViewController?

    func locationPermissionsWereDenied() {
        calledLocationPermissionsWereDenied = true
    }

    func goToNextPage(nextVC: UIViewController) {
        calledGoToNextPage = true
        goToNextPagePassedVC = nextVC
    }

    func goToLastPage(lastVC: UIViewController) {
        calledGoToLastPage = true
        goToLastPageVC = lastVC
    }
}
