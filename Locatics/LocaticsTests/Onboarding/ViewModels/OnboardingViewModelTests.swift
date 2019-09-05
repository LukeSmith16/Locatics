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

    private var viewBinder: MockOnboardingViewModelViewDelegate!
    private var locationPermManager: MockLocationPermissionsManager!
    var sut: OnboardingViewModel!

    override func setUp() {
        viewBinder = MockOnboardingViewModelViewDelegate()
        locationPermManager = MockLocationPermissionsManager()

        sut = OnboardingViewModel()
        sut.viewDelegate = viewBinder
        sut.locationPermissionsManager = locationPermManager
        sut.coordinator = self
    }

    override func tearDown() {
        expectation = nil
        viewBinder = nil
        locationPermManager = nil
        sut = nil
        super.tearDown()
    }

    func test_handleFinishOnboardingCalls_goToOnboardingFinished() {
        locationPermManager.authorizePermsState = true

        XCTAssertNotNil(sut.coordinator)

        expectation = XCTestExpectation(description: "Wait for goToOnboardingFinished to be called")
        sut.handleFinishOnboarding()

        wait(for: [expectation!], timeout: 2)
    }

    func test_handleFinishOnboardingWithoutAuthorizingPerms_callsPermDenied() {
        XCTAssertFalse(locationPermManager.calledAuthorizeLocationPermissions)

        sut.handleFinishOnboarding()

        XCTAssertTrue(viewBinder.calledLocationPermissionsWereDenied)
    }

    func test_locationPermsManagerDelegate_isNilByDefault() {
        XCTAssertNil(sut.locationPermissionsManager!.delegate)
    }

    func test_locationsPermsManagerDelegate_isNotNilAfterHandlePermsTapped() {
        sut.handlePermissionsTapped()

        XCTAssertNotNil(sut.locationPermissionsManager!.delegate)
    }

    func test_handlePermissionsTapped_callsAuthorizeLocationPermissions() {
        sut.handlePermissionsTapped()

        XCTAssertTrue(locationPermManager.calledAuthorizeLocationPermissions)
    }

    func test_handleGoToAppSettings_callsGoToAppSettings() {
        XCTAssertNotNil(sut.coordinator)

        expectation = XCTestExpectation(description: "Wait for goToAppSettings to be called")
        sut.handleGoToAppSettings()

        wait(for: [expectation!], timeout: 2)
    }

    func test_permissionsDenied_callsViewDelegatePermissionsWereDenied() {
        sut.permissionsDenied()

        XCTAssertTrue(viewBinder.calledLocationPermissionsWereDenied)
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

    func test_getPageViewControllerBefore_returnsCorrectOrderForPageVCs() {
        let onboardingWelcomePageVC = sut.getPageViewController(before: sut.pageViewControllers[1])!
        let onboardingAboutPageViewController = sut.getPageViewController(before: sut.pageViewControllers[2])!
        let onboardingPermissionsPageViewController = sut.getPageViewController(before: sut.pageViewControllers[3])!

        XCTAssertTrue(onboardingWelcomePageVC is OnboardingWelcomePageViewController)
        XCTAssertTrue(onboardingAboutPageViewController is OnboardingAboutPageViewController)
        XCTAssertTrue(onboardingPermissionsPageViewController is OnboardingPermissionsPageViewController)
    }

    func test_getPageViewControllerAfter_returnsCorrectOrderForPageVCs() {
        let onboardingAboutPageViewController = sut.getPageViewController(after: sut.pageViewControllers[0])!
        let onboardingPermissionsPageViewController = sut.getPageViewController(after: sut.pageViewControllers[1])!
        let onboardingGetStartedPageViewController = sut.getPageViewController(after: sut.pageViewControllers[2])!

        XCTAssertTrue(onboardingAboutPageViewController is OnboardingAboutPageViewController)
        XCTAssertTrue(onboardingPermissionsPageViewController is OnboardingPermissionsPageViewController)
        XCTAssertTrue(onboardingGetStartedPageViewController is OnboardingGetStartedPageViewController)
    }
}

extension OnboardingViewModelTests: OnboardingViewModelCoordinatorDelegate {
    func goToOnboardingFinished() {
        expectation?.fulfill()
    }

    func goToAppSettings() {
        expectation?.fulfill()
    }
}

private extension OnboardingViewModelTests {
    class MockLocationPermissionsManager: LocationPermissionsManagerInterface {

        var calledHasAuthorizedLocationPermissions = false
        var calledAuthorizeLocationPermissions = false

        var authorizePermsState = false

        weak var delegate: LocationPermissionsManagerDelegate?

        func hasAuthorizedLocationPermissions() -> Bool {
            calledHasAuthorizedLocationPermissions = true
            return authorizePermsState
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
