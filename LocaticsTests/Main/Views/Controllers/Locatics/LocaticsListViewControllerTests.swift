//
//  LocaticsViewControllerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsListViewControllerTests: XCTestCase {

    var sut: LocaticsListViewController!

    private var mockCollectionView: MockLocaticsListCollectionView!
    private var mockLocaticsViewModel: MockLocaticsViewModel!

    override func setUp() {
        sut = LocaticsListViewController()

        mockCollectionView = MockLocaticsListCollectionView(frame: .zero,
                                                            collectionViewLayout: UICollectionViewLayout())

        mockLocaticsViewModel = MockLocaticsViewModel()
        sut.locaticsViewModel = mockLocaticsViewModel

        _ = UINavigationController(rootViewController: sut)
        _ = sut.view
    }

    override func tearDown() {
        sut = nil
        mockLocaticsViewModel = nil
        super.tearDown()
    }

    func test_view_isNotNil() {
        XCTAssertNotNil(sut.view)
    }

    func test_locaticsListCollectionView_isNotNil() {
        XCTAssertNotNil(sut.locaticsListCollectionView)
    }

    func test_navigationTitleView_isNotNil() {
        XCTAssertNotNil(sut.navigationTitleView)
    }

    func test_mapView_isNotNil() {
        XCTAssertNotNil(sut.mapView)
    }

    func test_visualEffectView_isNotNil() {
        XCTAssertNotNil(sut.visualEffectView)
    }

    func test_locaticsViewModelDidSet_setsViewDelegate() {
        XCTAssertNotNil(mockLocaticsViewModel.viewDelegate)
    }

    func test_locaticsListCollectionViewViewModel_isNotNil() {
        XCTAssertNotNil(sut.locaticsListCollectionView.locaticsCollectionViewModel)
    }

    func test_viewWillAppear_callsPrepareLocaticsListCollectionViewAnimation() {
        sut.locaticsListCollectionView = mockCollectionView

        sut.beginAppearanceTransition(true, animated: true)

        XCTAssertEqual(mockCollectionView.alpha, 0.0)
    }

    func test_viewDidAppear_callsAnimateLocaticsListCollectionView() {
        sut.locaticsListCollectionView = mockCollectionView

        sut.beginAppearanceTransition(true, animated: true)
        sut.endAppearanceTransition()

        XCTAssertTrue(mockCollectionView.calledAnimate)
    }
}
