//
//  StorageManagerTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreData

@testable import Locatics
class StorageManagerTests: XCTestCase {

    var sut: StorageManager!

    private var mockPC: NSPersistentContainer!

    override func setUp() {
        mockPC = mockPersistentContainer()
        sut = StorageManager(psc: mockPC)
    }

    override func tearDown() {
        mockPC = nil
        sut = nil
        super.tearDown()
    }

    func test_storageManagerError_localizedDescriptionValues() {
        XCTAssertEqual(StorageManagerError.couldNotFindObject.localizedDescription,
                       "Could not find object matching ID.")
        XCTAssertEqual(StorageManagerError.badRequest.localizedDescription,
                       "Bad fetch request formed.")
    }

    func test_createObject_addsObjectToMoc() {
        let moc = mockPC.viewContext
        let coreDataObject = createLocalItem()

        XCTAssertEqual(moc.registeredObjects.count, 1)
        XCTAssertEqual(moc.registeredObjects.first!, coreDataObject)
    }

    func test_fetchObjects_returnsObjectsWhenRequestValid() {
        sut.fetchObjects(entity: DB_LocalItem.self, predicate: nil, sortDescriptors: nil) { (result) in
            switch result {
            case .success(let success):
                XCTAssertTrue(success.isEmpty)
            case .failure(let failure):
                XCTFail("Should not fail - \(failure.localizedDescription)")
            }
        }
    }

    func test_fetchObjects_returnsCorrectAmount() {
        _ = createLocalItem()
        _ = createLocalItem()
        _ = createLocalItem()

        sut.fetchObjects(entity: DB_LocalItem.self, predicate: nil, sortDescriptors: nil) { (result) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success.count, 3)
            case .failure(let failure):
                XCTFail("Should not fail - \(failure.localizedDescription)")
            }
        }
    }

    func test_fetchObjects_returnsCorrectAmountWithPredicate() {
        let coreDataObject = createLocalItem()
        _ = createLocalItem()
        _ = createLocalItem()

        let predicate = NSPredicate(format: "\(#keyPath(DB_LocalItem.identity)) == %ld", coreDataObject.identity)

        sut.fetchObjects(entity: DB_LocalItem.self, predicate: predicate, sortDescriptors: nil) { (result) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success.count, 1)
                XCTAssertEqual(success.first!.identity, coreDataObject.identity)
            case .failure(let failure):
                XCTFail("Should not fail - \(failure.localizedDescription)")
            }
        }
    }

    func test_updateObject_updatesAndReturnsObjectWithValidID() {
        let coreDataObject = createLocalItem()

        sut.updateObject(entity: DB_LocalItem.self, identity: coreDataObject.identity, updatedValues: [:]) { (result) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success, coreDataObject)
            case .failure(let failure):
                XCTFail("Should be able to find object by it's identity - \(failure.localizedDescription)")
            }
        }
    }

    func test_updateObject_completesWithErrorWhenPassedInvalidID() {
        _ = createLocalItem()

        sut.updateObject(entity: DB_LocalItem.self, identity: 0, updatedValues: [:]) { (result) in
            switch result {
            case .success(let success):
                XCTFail("Should not be able to find object by ID - \(success)")
            case .failure(let failure):
                XCTAssertTrue(failure == .couldNotFindObject)
            }
        }
    }

    func test_deleteObject_removesObjectFromMoc() {
        let moc = mockPC.viewContext
        let coreDataObject = createLocalItem()

        let expect = expectation(description: "Wait for moc perform changes")

        sut.deleteObject(entity: DB_LocalItem.self, identity: coreDataObject.identity) { (error) in
            guard error == nil else {
                XCTFail("Should be able to find object with valid ID - \(error!.localizedDescription)")
                return
            }

            XCTAssertEqual(moc.deletedObjects.count, 1)
            XCTAssertEqual(moc.deletedObjects.first!, coreDataObject)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 3)

        XCTAssertEqual(moc.deletedObjects.count, 0)
        XCTAssertEqual(moc.registeredObjects.count, 0)
    }

    func test_deleteObject_returnsErrorWhenIdInvalid() {
        let moc = mockPC.viewContext
        _ = createLocalItem()

        sut.deleteObject(entity: DB_LocalItem.self, identity: 0) { (error) in
            guard let error = error else {
                XCTFail("Should not continue if object ID is invalid")
                return
            }

            XCTAssertEqual(moc.deletedObjects.count, 0)
            XCTAssertTrue(error == .couldNotFindObject)
        }
    }
}

private extension StorageManagerTests {
    func createLocalItem(withValues values: [String: Any] = [:]) -> DB_LocalItem {
        let moc = mockPC.viewContext
        var coreDataObject: DB_LocalItem?

        let expect = expectation(description: "Wait for moc perform changes")

        sut.createObject(entity: DB_LocalItem.self, values: values) { (object) in
            coreDataObject = object

            XCTAssertEqual(moc.insertedObjects.count, 1)
            expect.fulfill()
        }

        wait(for: [expect], timeout: 3)

        XCTAssertNotNil(coreDataObject)
        XCTAssertEqual(moc.insertedObjects.count, 0)

        return coreDataObject!
    }
}
