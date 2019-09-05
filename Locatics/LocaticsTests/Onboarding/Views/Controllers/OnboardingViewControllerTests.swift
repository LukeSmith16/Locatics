//
//  OnboardingViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingViewControllerTests: XCTestCase {

    private var viewModel: MockOnboardingViewModel!
    var sut: OnboardingViewController!

    override func setUp() {
        viewModel = MockOnboardingViewModel()

        sut = OnboardingViewController()
        sut.onboardingViewModel = viewModel

        _ = sut.view
    }

    override func tearDown() {
        viewModel = nil
        sut = nil
        super.tearDown()
    }

    func test_view_isNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_pageViewController_isDataSource() {
        XCTAssertNotNil(sut.dataSource)
    }

    func test_pageViewController_isDelegate() {
        XCTAssertNotNil(sut.delegate)
    }

    func test_doneTapped_callsHandleFinishOnboarding() {
        sut.doneTapped(UIButton())

        XCTAssertTrue(viewModel.calledHandleFinishOnboarding)
    }

    func test_permissionsTapped_callsHandlePermissionsTapped() {
        sut.permissionsTapped(UIButton())

        XCTAssertTrue(viewModel.calledHandlePermissionsTapped)
    }

    func test_viewControllerPages_isNotNil() {
        XCTAssertNotNil(sut.viewControllers)
        XCTAssertTrue(sut.presentationCount(for: sut) == 4)
    }

    func test_pageVCBefore_callsViewModelBeforeVC() {
        _ = sut.pageViewController(sut, viewControllerBefore: UIViewController())

        XCTAssertTrue(viewModel.calledGetPageVCBefore)
    }

    func test_pageVCBefore_isViewModelBeforeVC() {
        let pageVCBefore = sut.pageViewController(sut, viewControllerBefore: UIViewController())

        XCTAssertTrue(pageVCBefore is OnboardingWelcomePageViewController)
    }

    func test_pageVCBefore_callsViewModelAfterVC() {
        _ = sut.pageViewController(sut, viewControllerAfter: UIViewController())

        XCTAssertTrue(viewModel.calledGetPageVCAfter)
    }

    func test_pageVCBefore_isViewModelAfterVC() {
        let pageVCAfter = sut.pageViewController(sut, viewControllerAfter: UIViewController())

        XCTAssertTrue(pageVCAfter is OnboardingPermissionsPageViewController)
    }
}

private extension OnboardingViewControllerTests {
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
}
