//
//  OnboardingNavigationViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class OnboardingNavigationViewModelTests: XCTestCase {

    var sut: OnboardingNavigationViewModel!

    private var mockOnboardingNavigationViewModelObserver: MockOnboardingNavigationViewModelViewDelegate!

    override func setUp() {
        sut = OnboardingNavigationViewModel(onboardingIndex: 0)
        mockOnboardingNavigationViewModelObserver = MockOnboardingNavigationViewModelViewDelegate()
        sut.delegate = mockOnboardingNavigationViewModelObserver
    }

    override func tearDown() {
        sut = nil
        mockOnboardingNavigationViewModelObserver = nil
        super.tearDown()
    }

    func test_nextTapped_callsViewDelegateNextWasTapped() {
        sut.nextTapped()

        XCTAssertTrue(mockOnboardingNavigationViewModelObserver.calledNextWasTapped)
    }

    func test_nextTapped_callsViewDelegateNextWasTappedPassingIndex() {
        sut.nextTapped()

        XCTAssertEqual(mockOnboardingNavigationViewModelObserver.nextWasTappedPassedIndex!, 0)
    }

    func test_skipTapped_callsViewDelegateSkipWasTapped() {
        sut.skipTapped()

        XCTAssertTrue(mockOnboardingNavigationViewModelObserver.calledSkipWasTapped)
    }
}
