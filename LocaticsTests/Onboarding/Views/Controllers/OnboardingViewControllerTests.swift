//
//  OnboardingViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable line_length

import XCTest

@testable import Locatics
class OnboardingViewControllerTests: XCTestCase {

    var sut: OnboardingViewController!

    private var mockOnboardingViewModel: MockOnboardingViewModel!

    override func setUp() {
        mockOnboardingViewModel = MockOnboardingViewModel()

        let onboardingStoryboard = UIStoryboard.Storyboard.onboarding
        sut = onboardingStoryboard.instantiateViewController(withIdentifier: "OnboardingViewController") as? OnboardingViewController
        sut.onboardingViewModel = mockOnboardingViewModel

        _ = sut.view
    }

    override func tearDown() {
        mockOnboardingViewModel = nil
        sut = nil
        super.tearDown()
    }

    func test_view_isNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_backgroundColor_isThemeBackground() {
        XCTAssertEqual(sut.view.backgroundColor,
                       UIColor(colorTheme: .Background))
    }

    func test_pageViewController_isDataSource() {
        XCTAssertNotNil(sut.dataSource)
    }

    func test_pageViewController_isDelegate() {
        XCTAssertNotNil(sut.delegate)
    }

    func test_pageControl_numberOfPagesIsFour() {
        XCTAssertEqual(sut.pageControl.numberOfPages, 4)
    }

    func test_pageControl_startingPageIsZero() {
        XCTAssertEqual(sut.pageControl.currentPage, 0)
    }

    func test_nextTapped_callsNextWasTapped() {
        sut.nextTapped(UIButton())

        XCTAssertTrue(mockOnboardingViewModel.calledNextWasTapped)
    }

    func test_nextTapped_passesCurrentIndex() {
        sut.nextTapped(UIButton())

        XCTAssertEqual(mockOnboardingViewModel.nextWasTappedPassedValue!,
                       0)
    }

    func test_skipTapped_callsSkipWasTapped() {
        sut.skipTapped(UIButton())

        XCTAssertTrue(mockOnboardingViewModel.calledSkipWasTapped)
    }

    func test_doneTapped_callsHandleFinishOnboarding() {
        sut.doneTapped(UIButton())

        XCTAssertTrue(mockOnboardingViewModel.calledHandleFinishOnboarding)
    }

    func test_permissionsTapped_callsHandlePermissionsTapped() {
        sut.permissionsTapped(UIButton())

        XCTAssertTrue(mockOnboardingViewModel.calledHandlePermissionsTapped)
    }

    func test_viewControllerPages_isNotNil() {
        XCTAssertNotNil(sut.viewControllers)
        XCTAssertTrue(sut.presentationCount(for: sut) == 4)
    }

    func test_pageVCBefore_callsViewModelBeforeVC() {
        _ = sut.pageViewController(sut, viewControllerBefore: UIViewController())

        XCTAssertTrue(mockOnboardingViewModel.calledGetPageVCBefore)
    }

    func test_pageVCBefore_isViewModelBeforeVC() {
        let pageVCBefore = sut.pageViewController(sut, viewControllerBefore: UIViewController())

        XCTAssertTrue(pageVCBefore is OnboardingWelcomePageViewController)
    }

    func test_pageVCBefore_callsViewModelAfterVC() {
        _ = sut.pageViewController(sut, viewControllerAfter: UIViewController())

        XCTAssertTrue(mockOnboardingViewModel.calledGetPageVCAfter)
    }

    func test_pageVCBefore_isViewModelAfterVC() {
        let pageVCAfter = sut.pageViewController(sut, viewControllerAfter: UIViewController())

        XCTAssertTrue(pageVCAfter is OnboardingPermissionsPageViewController)
    }

    func test_pageVCWillTransitionTo_callsIndexOf() {
        sut.pageViewController(sut, willTransitionTo: [UIViewController()])

        XCTAssertTrue(mockOnboardingViewModel.calledIndexOf)
    }

    func test_pageVCWillTransitionTo_passesTransitioningVCToIndexOf() {
        let nextVC = UIViewController()
        sut.pageViewController(sut, willTransitionTo: [nextVC, UIViewController()])

        XCTAssertEqual(mockOnboardingViewModel.indexOfPassedValue!, nextVC)
    }

    func test_pageVCDidFinishAnimating_returnsIfNotCompleted() {
        sut.pageViewController(sut,
                               didFinishAnimating: true,
                               previousViewControllers: [UIViewController()],
                               transitionCompleted: false)

        XCTAssertEqual(sut.pageControl.currentPage, 0)
    }

    func test_pageVCDidFinishAnimating_returnsIfPendingIndexIsNil() {
        sut.pageViewController(sut,
                               didFinishAnimating: true,
                               previousViewControllers: [UIViewController()],
                               transitionCompleted: true)

        XCTAssertEqual(sut.pageControl.currentPage, 0)
    }

    func test_pageVCDidFinishAnimating_updatesCurrentPageToPendingIndex() {
        sut.pageControl.currentPage = 10

        sut.pageViewController(sut, willTransitionTo: [UIViewController()])
        sut.pageViewController(sut,
                               didFinishAnimating: true,
                               previousViewControllers: [UIViewController()],
                               transitionCompleted: true)

        XCTAssertEqual(sut.pageControl.currentPage, 0)
    }

    func test_goToNextPage_incrementsPageControlCurrentPage() {
        sut.goToNextPage(nextVC: UIViewController())

        XCTAssertEqual(sut.pageControl.currentPage, 1)
    }

    func test_goToLastPage_setsPageControlCurrentPageToFour() {
        sut.goToLastPage(lastVC: UIViewController())

        XCTAssertEqual(sut.pageControl.currentPage, 3)
    }
}
