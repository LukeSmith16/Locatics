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

    var sut: OnboardingViewController!

    override func setUp() {
        sut = OnboardingViewController()
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_viewIsNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_isPageViewControllerDataSource() {
        XCTAssertNotNil(sut.dataSource)
    }

    func test_isPageViewControllerDelegate() {
        XCTAssertNotNil(sut.delegate)
    }

    func test_viewControllerPagesIsNotNil() {
        XCTAssertNotNil(sut.viewControllers)
        XCTAssertTrue(sut.presentationCount(for: sut) == 4)
    }

    func test_viewControllerPagesAfter() {
        XCTAssertNil(sut.pageViewController(sut, viewControllerAfter: UIViewController()))

        XCTAssertTrue(sut.viewControllers!.first! is OnboardingWelcomePageViewController)

        XCTAssertTrue(getPageViewVCAfterVC(sut.pageViewControllers[0]) is OnboardingAboutPageViewController)
        XCTAssertTrue(getPageViewVCAfterVC(sut.pageViewControllers[1]) is OnboardingPermissionsPageViewController)
        XCTAssertTrue(getPageViewVCAfterVC(sut.pageViewControllers[2]) is OnboardingGetStartedPageViewController)
    }

    func test_viewControllerPagesBefore() {
         XCTAssertNil(sut.pageViewController(sut, viewControllerBefore: UIViewController()))

        XCTAssertTrue(getPageViewVCBeforeVC(sut.pageViewControllers[3]) is OnboardingPermissionsPageViewController)
        XCTAssertTrue(getPageViewVCBeforeVC(sut.pageViewControllers[2]) is OnboardingAboutPageViewController)
        XCTAssertTrue(getPageViewVCBeforeVC(sut.pageViewControllers[1]) is OnboardingWelcomePageViewController)
    }
}

private extension OnboardingViewControllerTests {
    func getPageViewVCAfterVC(_ viewController: UIViewController) -> UIViewController? {
        return sut.pageViewController(sut, viewControllerAfter: viewController)
    }

    func getPageViewVCBeforeVC(_ viewController: UIViewController) -> UIViewController? {
        return sut.pageViewController(sut, viewControllerBefore: viewController)
    }
}
