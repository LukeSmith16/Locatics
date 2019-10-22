//
//  LocaticsCollectionViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticsCollectionViewModelTests: XCTestCase {

    var sut: LocaticsCollectionViewModel!

    private var mockViewModelViewObserver: MockLocaticsCollectionViewModelViewDelegate!
    private var mockLocaticStorage: MockLocaticStorage!

    override func setUp() {
        sut = LocaticsCollectionViewModel()
        mockViewModelViewObserver = MockLocaticsCollectionViewModelViewDelegate()
        mockLocaticStorage = MockLocaticStorage()

        sut.viewDelegate = mockViewModelViewObserver
    }

    override func tearDown() {
        sut = nil
        mockLocaticStorage = nil
        super.tearDown()
    }

    func test_conformsTo_locaticStoragePersistentStorageObserver() {
        sut.locaticStorage = mockLocaticStorage

        let expect = expectation(description: "Wait for PersistentStorageObserver")

        mockLocaticStorage.persistentStorageObserver.invoke { (delegate) in
            delegate.locaticWasInserted(MockLocatic())
            expect.fulfill()
        }

        wait(for: [expect], timeout: 3)

        XCTAssertTrue(mockViewModelViewObserver.calledLocaticCellViewModelWasAdded)
    }

    func test_locaticStorageDidSet_callsLocaticStorageFetchLocatics() {
        sut.locaticStorage = mockLocaticStorage

        XCTAssertTrue(mockLocaticStorage.calledFetchLocatics)
    }

    func test_locaticsCount_isEqualToLocaticCellViewModelsCount() {
        XCTAssertEqual(sut.locaticsCount(), sut.locaticCellViewModels.count)
    }

    func test_locaticAtIndex_returnsLocaticAtIndex() {
        let newLocaticCellViewModel = LocaticCellViewModel(locatic: MockLocatic())
        sut.locaticCellViewModels.append(newLocaticCellViewModel)

        let locaticAtIndex = sut.locaticAtIndex(IndexPath(item: 0, section: 0))

        XCTAssertEqual(locaticAtIndex.locatic.identity,
                       newLocaticCellViewModel.locatic.identity)
    }

    func test_fetchAllLocatics_setsUpLocaticCellViewModels() {
        sut.locaticStorage = mockLocaticStorage

        XCTAssertEqual(sut.locaticCellViewModels.count, 2)
    }

    func test_setupLocaticCellViewModels_callsViewDelegateReloadData() {
        sut.locaticStorage = mockLocaticStorage

        XCTAssertTrue(mockViewModelViewObserver.calledReloadData)
    }

    func test_locaticWasInserted_addsLocaticToArray() {
        sut.locaticWasInserted(MockLocatic())

        XCTAssertEqual(sut.locaticCellViewModels.count, 1)
    }

    func test_locaticWasInserted_callsViewDelegateLocaticCellViewModelWasAdded() {
        sut.locaticWasInserted(MockLocatic())

        XCTAssertTrue(mockViewModelViewObserver.calledLocaticCellViewModelWasAdded)
        XCTAssertEqual(mockViewModelViewObserver.passedLocaticCellViewModelWasAdded!, 0)
    }

    func test_locaticWasUpdated_updatesLocaticInArray() {
        let oldLocatic = MockLocatic()
        sut.locaticCellViewModels.append(LocaticCellViewModel(locatic: oldLocatic))

        let newLocatic = MockLocatic()
        newLocatic.name = "NewLocatic"

        sut.locaticWasUpdated(newLocatic)

        XCTAssertEqual(sut.locaticCellViewModels.count, 1)

        let locatic = sut.locaticCellViewModels.first!.locatic
        XCTAssertEqual(locatic.identity,
                       oldLocatic.identity)
        XCTAssertEqual(locatic.name, newLocatic.name)
    }

    func test_locaticWasUpdated_callsLocaticCellViewModelWasUpdated() {
        sut.locaticCellViewModels.append(LocaticCellViewModel(locatic: MockLocatic()))

        sut.locaticWasUpdated(MockLocatic())

        XCTAssertTrue(mockViewModelViewObserver.calledLocaticCellViewModelWasUpdated)
        XCTAssertEqual(mockViewModelViewObserver.passedLocaticCellViewModelWasUpdatedIndex, 0)
    }

    func test_locaticWasUpdated_returnsIfIndexNotFound() {
        sut.locaticWasUpdated(MockLocatic())

        XCTAssertFalse(mockViewModelViewObserver.calledLocaticCellViewModelWasUpdated)
    }

    func test_locaticWasDeleted_removesLocaticFromArray() {
        let locatic = MockLocatic()
        sut.locaticCellViewModels.append(LocaticCellViewModel(locatic: locatic))

        sut.locaticWasDeleted(locatic)

        XCTAssertTrue(sut.locaticCellViewModels.isEmpty)
    }

    func test_locaticWasDeleted_callsLocaticCellViewModelWasRemoved() {
        let locatic = MockLocatic()
        sut.locaticCellViewModels.append(LocaticCellViewModel(locatic: locatic))

        sut.locaticWasDeleted(locatic)

        XCTAssertTrue(mockViewModelViewObserver.calledLocaticCellViewModelWasRemoved)
    }

    func test_locaticWasDeleted_returnsIfIndexNotFound() {
        sut.locaticWasDeleted(MockLocatic())

        XCTAssertFalse(mockViewModelViewObserver.calledLocaticCellViewModelWasRemoved)
    }
}
