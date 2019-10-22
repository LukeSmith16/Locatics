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

    private var mockLocaticsViewModel: MockLocaticsViewModel!

    override func setUp() {
        sut = LocaticsListViewController()
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

    func test_setupTabItemImage_setsTabItem() {
        XCTAssertNotNil(sut.navigationController?.tabItem.image(for: .normal))
        XCTAssertNotNil(sut.navigationController?.tabItem.image(for: .selected))
    }

    func test_navigationTitleView_isNotNil() {
        XCTAssertNotNil(sut.navigationTitleView)
    }

    func test_locaticsViewModelDidSet_setsViewDelegate() {
        XCTAssertNotNil(mockLocaticsViewModel.viewDelegate)
    }

    func test_locaticsListCollectionViewViewModel_isNotNil() {
        XCTAssertNotNil(sut.locaticsListCollectionView.locaticsCollectionViewModel)
    }
}
