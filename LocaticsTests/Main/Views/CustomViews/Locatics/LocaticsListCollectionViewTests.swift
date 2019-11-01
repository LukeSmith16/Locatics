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

        XCTAssertEqual(flowLayout.itemSize.width,
                       sut.bounds.width)
        XCTAssertEqual(flowLayout.itemSize.height,
                       ScreenDesignable.cellHeight)

        XCTAssertEqual(flowLayout.minimumInteritemSpacing,
                       0)
        XCTAssertEqual(flowLayout.minimumLineSpacing,
                       35)
        XCTAssertTrue(flowLayout.scrollDirection == .vertical)
    }

    func test_numberOfItemsInSection_returnsItemCountFromViewModel() {
        let viewModelItemCount = mockLocaticsCollectionViewModel.locaticsCount()

        XCTAssertEqual(viewModelItemCount, sut.numberOfItems(inSection: 0))
    }

    func test_cellForItemAt_dequeuesCell() {
        _ = addLocaticCellViewModel()

        let mockCollectionView = MockLocaticsListCollectionView(frame: .zero,
                                                                collectionViewLayout: UICollectionViewFlowLayout())
        mockCollectionView.dataSource = sut
        mockCollectionView.delegate = sut
        mockCollectionView.register(LocaticCollectionViewCell.self,
                                    forCellWithReuseIdentifier: "LocaticCollectionViewCell")

        mockCollectionView.reloadData()
        _ = mockCollectionView.collectionView(mockCollectionView,
                                              cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(mockCollectionView.cellGotDequeued)
    }

    func test_cellForItemAt_dequeuesLocaticCell() {
        _ = addLocaticCellViewModel()

        let cell = sut.collectionView(sut, cellForItemAt: IndexPath(item: 0,
                                                                     section: 0))

        XCTAssertTrue(cell is LocaticCollectionViewCell)
    }

    func test_cellForItemAt_callsLocaticAtIndex() {
        _ = addLocaticCellViewModel()

        sut.reloadData()

        _ = sut.collectionView(sut, cellForItemAt: IndexPath(item: 0, section: 0))

        XCTAssertTrue(mockLocaticsCollectionViewModel.calledLocaticAtIndex)
    }

    func test_cellForItemAt_configuresLocaticCell() {
        let locaticCellViewModel = addLocaticCellViewModel()

        sut.reloadData()

        guard let locaticCell = sut.collectionView(sut, cellForItemAt: IndexPath(item: 0, section: 0)) as? LocaticCollectionViewCell else {
            XCTFail("Cell should be of type 'LocaticCollectionViewCell'")
            return
        }

        XCTAssertNotNil(locaticCell.locaticCellViewModel)
        XCTAssertEqual(locaticCell.locaticCellViewModel?.locatic.identity,
                       locaticCellViewModel.locatic.identity)
    }

    func test_locaticCellViewModelWasUpdated_updatesItemAtIndexPath() {
        mockLocaticsCollectionViewModel.locaticCellViewModels = [LocaticCellViewModel(locatic: MockLocatic()),
                                                                 LocaticCellViewModel(locatic: MockLocatic()),
                                                                 LocaticCellViewModel(locatic: MockLocatic()),
                                                                 LocaticCellViewModel(locatic: MockLocatic()),
                                                                 LocaticCellViewModel(locatic: MockLocatic())]
        let mockCollectionView = setupMockCollectionView()

        let expect = expectation(description: "Wait for performBatchUpdates")
        mockCollectionView.expectation = expect

        mockLocaticsCollectionViewModel.locaticsReturnCount = 4
        mockCollectionView.locaticCellViewModelWasUpdated(atIndex: 3)

        wait(for: [expect], timeout: 3)

        XCTAssertTrue(mockCollectionView.calledPerformBatchUpdates)
        XCTAssertTrue(mockCollectionView.reloadedItems)

        XCTAssertEqual(mockCollectionView.passedIndexPath!,
                       IndexPath(item: 3, section: 0))
    }
}

private extension LocaticsListCollectionViewTests {
    func addLocaticCellViewModel() -> LocaticCellViewModelInterface {
        let locaticCellViewModel = LocaticCellViewModel(locatic: MockLocatic())
        mockLocaticsCollectionViewModel.locaticCellViewModels.append(locaticCellViewModel)
        mockLocaticsCollectionViewModel.locaticsReturnCount = 1

        return locaticCellViewModel
    }

    func setupMockCollectionView() -> MockLocaticsListCollectionView {
        let mockCollectionView = MockLocaticsListCollectionView(frame: .zero,
                                                                collectionViewLayout: UICollectionViewLayout())
        mockCollectionView.dataSource = sut
        mockCollectionView.delegate = sut

        return mockCollectionView
    }
}
