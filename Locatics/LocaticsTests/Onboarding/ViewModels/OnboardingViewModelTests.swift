//
//  OnboardingViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingViewModelTests: XCTestCase {

    var expectation: XCTestExpectation?

    private var viewDelegate: MockOnboardingViewModelViewDelegate!
    private var locationPermManager: MockLocationPermissionsManager!
    var sut: OnboardingViewModel!

    override func setUp() {
        viewDelegate = MockOnboardingViewModelViewDelegate()
        locationPermManager = MockLocationPermissionsManager()

        sut = OnboardingViewModel()
        sut.viewDelegate = viewDelegate
        sut.locationPermissionsManager = locationPermManager
        sut.coordinatorDelegate = self
    }

    override func tearDown() {
        viewDelegate = nil
        locationPermManager = nil
        sut = nil
        super.tearDown()
    }

    func test_handleFinishOnboardingCallsGoToOnboardingFinished() {
        XCTAssertNotNil(sut.coordinatorDelegate)

        expectation = XCTestExpectation(description: "Wait for goToOnboardingFinished to be called")
        sut.handleFinishOnboarding()

        wait(for: [expectation!], timeout: 2)
    }

    func test_handlePermissionsTapped_callsAuthorizeLocationPermissions() {
        sut.handlePermissionsTapped()

        XCTAssertTrue(locationPermManager.calledAuthorizeLocationPermissions)
    }

    func test_permissionsDenied_callsViewDelegatePermissionsWereDenied() {
        sut.permissionsDenied()

        XCTAssertTrue(viewDelegate.calledLocationPermissionsWereDenied)
    }

    func test_getInitialPageVC_isOnboardingWelcomePageVC() {
        let initialPageVC = sut.getInitialPageViewController()

        XCTAssertTrue(initialPageVC is OnboardingWelcomePageViewController)
    }

    func test_pageViewControllerCount_isFour() {
        let pageVCCount = sut.pageViewControllerCount()

        XCTAssertEqual(pageVCCount, 4)
    }

    func test_getPageVCBeforeInvalidVC_isNil() {
        let invalidBeforePageVC = sut.getPageViewController(before: UIViewController())

        XCTAssertNil(invalidBeforePageVC)
    }

    func test_getPageVCAfterInvalidVC_isNil() {
        let invalidAfterPageVC = sut.getPageViewController(after: UIViewController())

        XCTAssertNil(invalidAfterPageVC)
    }
}

extension OnboardingViewModelTests: OnboardingViewModelCoordinatorDelegate {
    func goToOnboardingFinished() {
        expectation?.fulfill()
    }
}

private extension OnboardingViewModelTests {
    class MockLocationPermissionsManager: LocationPermissionsManagerInterface {

        var calledHasAuthorizedLocationPermissions = false
        var calledAuthorizeLocationPermissions = false

        weak var delegate: LocationPermissionsManagerDelegate?

        func hasAuthorizedLocationPermissions() -> Bool {
            calledHasAuthorizedLocationPermissions = true
            return true
        }

        func authorizeLocationPermissions() {
            calledAuthorizeLocationPermissions = true
        }
    }

    class MockOnboardingViewModelViewDelegate: OnboardingViewModelViewDelegate {
        var calledLocationPermissionsWereDenied = false

        func locationPermissionsWereDenied() {
            calledLocationPermissionsWereDenied = true
        }
    }
}
