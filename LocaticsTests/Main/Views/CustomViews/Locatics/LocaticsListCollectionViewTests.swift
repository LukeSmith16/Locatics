//
//  LocaticsListCollectionViewTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsListCollectionViewTests: XCTestCase {

    var sut: LocaticsListCollectionView!

    private var mockLocaticsCollectionViewModel: MockLocaticsCollectionViewModel!

    override func setUp() {
        sut = LocaticsListCollectionView(frame: CGRect.zero,
                                         collectionViewLayout: UICollectionViewLayout())
        mockLocaticsCollectionViewModel = MockLocaticsCollectionViewModel()

        sut.locaticsCollectionViewModel = mockLocaticsCollectionViewModel
    }

    override func tearDown() {
        sut = nil
        mockLocaticsCollectionViewModel = nil
        super.tearDown()
    }

    func test_locaticsCollectionViewModelDidSet_setsViewDelegate() {
        XCTAssertNotNil(sut.locaticsCollectionViewModel)
    }

    func test_collectionViewDelegate_isNotNil() {
        XCTAssertNotNil(sut.delegate)
    }

    func test_collectionViewDataSourceIsNotNil() {
        XCTAssertNotNil(sut.dataSource)
    }

    func test_setupLayout_configuresFlowLayout() {
        let layout = sut.collectionViewLayout

        guard let flowLayout = layout as? UICollectionViewFlowLayout else {
            XCTFail("Layout should be of type 'UICollectionViewFlowLayout'")
            return
        }

        XCTAssertEqual(flowLayout.minimumInteritemSpacing,
                       0)
        XCTAssertEqual(flowLayout.minimumLineSpacing,
                       25)
        XCTAssertTrue(flowLayout.scrollDirection == .vertical)
    }

    func test_numberOfItemsInSection_returnsItemCountFromViewModel() {
        let viewModelItemCount = mockLocaticsCollectionViewModel.locaticsCount()

        XCTAssertEqual(viewModelItemCount, sut.numberOfItems(inSection: 0))
    }

    func test_cellForItemAt_dequeuesCell() {
        let mockCollectionView = MockCollectionView(frame: .zero,
                                                    collectionViewLayout: UICollectionViewFlowLayout())
        mockCollectionView.dataSource = sut
        mockCollectionView.register(LocaticCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "LocaticCollectionViewCell")

        _ = mockCollectionView.cellForItem(at: IndexPath(item: 0, section: 0))

        XCTAssertTrue(mockCollectionView.cellGotDequeued)
    }

    func test_cellForItemAt_dequeuesLocaticCell() {
        let cell = sut.collectionView(sut, cellForItemAt: IndexPath(item: 0,
                                                                     section: 0))

        XCTAssertTrue(cell is LocaticCollectionViewCell)
    }

//    func test_cellForItemAt_configuresLocaticCell() {
//        guard let locaticCell = sut.collectionView(sut, cellForItemAt: IndexPath(item: 0, section: 0)) as? LocaticCollectionViewCell else {
//            XCTFail("Cell should be of type 'MockLocaticCollectionViewCell'")
//            return
//        }
//
//        // TODO: Check values are passed through to LocaticCell
//    }
}
