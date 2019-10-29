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

    private var mockViewModelViewObserver: MockOnboardingViewModelViewDelegate!
    private var mockLocationPermManager: MockLocationPermissionsManager!
    var sut: OnboardingViewModel!

    override func setUp() {
        mockViewModelViewObserver = MockOnboardingViewModelViewDelegate()
        mockLocationPermManager = MockLocationPermissionsManager()

        sut = OnboardingViewModel()
        sut.viewDelegate = mockViewModelViewObserver
        sut.onboardingNavigationViewModels = [MockOnboardingNavigationViewModel(),
                                              MockOnboardingNavigationViewModel(),
                                              MockOnboardingNavigationViewModel(),
                                              MockOnboardingNavigationViewModel()]
        sut.locationPermissionsManager = mockLocationPermManager
        sut.coordinator = self
    }

    override func tearDown() {
        expectation = nil
        mockViewModelViewObserver = nil
        mockLocationPermManager = nil
        sut = nil

        let domain = Bundle.main.bundleIdentifier!
        UserDefaults.standard.removePersistentDomain(forName: domain)
        UserDefaults.standard.synchronize()

        super.tearDown()
    }

    func test_onboardingStoryboardIdentifier_rawValues() {
        XCTAssertEqual(OnboardingStoryboardIdentifier.onboardingWelcomePageViewController.rawValue,
                       "OnboardingWelcomePageViewController")
        XCTAssertEqual(OnboardingStoryboardIdentifier.onboardingAboutPageViewController.rawValue,
                       "OnboardingAboutPageViewController")
        XCTAssertEqual(OnboardingStoryboardIdentifier.onboardingPermissionsPageViewController.rawValue,
                       "OnboardingPermissionsPageViewController")
        XCTAssertEqual(OnboardingStoryboardIdentifier.onboardingGetStartedPageViewController.rawValue,
                       "OnboardingGetStartedPageViewController")
    }

    func test_pageViewControllers_eachHaveAViewModel() {
        for pageVC in sut.pageViewControllers {
            let onboardingVC = pageVC as? OnboardingViewControllerDesignable

            XCTAssertNotNil(onboardingVC)
            XCTAssertNotNil(onboardingVC?.onboardingNavigationViewModel)
        }
    }

    func test_handleFinishOnboardingCalls_goToOnboardingFinished() {
        mockLocationPermManager.authorizePermsState = .authorizedAlways

        XCTAssertNotNil(sut.coordinator)

        expectation = XCTestExpectation(description: "Wait for goToOnboardingFinished to be called")
        sut.handleFinishOnboarding()

        wait(for: [expectation!], timeout: 2)
    }

    func test_handleFinishOnboardingWithoutAuthorizingPerms_callsPermDenied() {
        mockLocationPermManager.authorizePermsState = .denied

        XCTAssertFalse(mockLocationPermManager.calledAuthorizeLocationPermissions)

        sut.handleFinishOnboarding()

        XCTAssertTrue(mockViewModelViewObserver.calledLocationPermissionsWereDenied)
    }

    func test_handleFinishOnboarding_setsOnboardingValueTrue() {
        mockLocationPermManager.authorizePermsState = .authorizedAlways

        XCTAssertFalse(OnboardingManager.hasOnboarded())

        sut.handleFinishOnboarding()

        XCTAssertTrue(OnboardingManager.hasOnboarded())
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

        XCTAssertTrue(mockLocationPermManager.calledAuthorizeLocationPermissions)
    }

    func test_handleGoToAppSettings_callsGoToAppSettings() {
        XCTAssertNotNil(sut.coordinator)

        expectation = XCTestExpectation(description: "Wait for goToAppSettings to be called")
        sut.handleGoToAppSettings()

        wait(for: [expectation!], timeout: 2)
    }

    func test_permissionsDenied_callsViewDelegatePermissionsWereDenied() {
        sut.permissionsDenied()

        XCTAssertTrue(mockViewModelViewObserver.calledLocationPermissionsWereDenied)
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

    func test_nextWasTapped_callsGoToNextPage() {
        sut.nextWasTapped(atIndex: 0)

        XCTAssertTrue(mockViewModelViewObserver.calledGoToNextPage)
    }

    func test_nextWasTapped_callsGoToNextPageWithNextVC() {
        sut.nextWasTapped(atIndex: 1)

        XCTAssertTrue(mockViewModelViewObserver.goToNextPagePassedVC! is OnboardingPermissionsPageViewController)
    }

    func test_nextWasTapped_returnsIfIndexOutOfRange() {
        sut.nextWasTapped(atIndex: 10)

        XCTAssertFalse(mockViewModelViewObserver.calledGoToNextPage)
    }

    func test_skipWasTapped_callsGoToLastPage() {
        sut.skipWasTapped()

        XCTAssertTrue(mockViewModelViewObserver.calledGoToLastPage)
    }

    func test_skipWasTapped_callsGoToLastPageWithLastVC() {
        sut.skipWasTapped()

        XCTAssertTrue(mockViewModelViewObserver.goToLastPageVC! is OnboardingGetStartedPageViewController)
    }

    func test_handleAuthorizationError_callsHandlePermissionsTappedIfAuthStatusUndetermined() {
        mockLocationPermManager.authorizePermsState = .notDetermined

        sut.handleFinishOnboarding()

        XCTAssertTrue(mockLocationPermManager.calledAuthorizeLocationPermissions)
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
