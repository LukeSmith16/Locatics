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
        let coreDataObject = createLocatic()

        XCTAssertEqual(moc.registeredObjects.count, 1)
        XCTAssertEqual(moc.registeredObjects.first!, coreDataObject)
    }

    func test_createObject_createsObjectWithPassedValues() {
        let values: [String: Any] = ["name": "NewLocatic",
                                     "radius": 10,
                                     "longitude": 15,
                                     "latitude": 33]

        let expect = expectation(description: "Wait for create object to finish")
        var expectedObject: Locatic?

        sut.createObject(entity: Locatic.self, values: values) { (result) in
            switch result {
            case .success(let success):
                expectedObject = success
                expect.fulfill()
            case .failure(let failure):
                XCTFail("Should not fail with correct values passed - \(failure)")
            }
        }

        wait(for: [expect], timeout: 3)

        XCTAssertNotNil(expectedObject)
        XCTAssertEqual(expectedObject!.name, "NewLocatic")
        XCTAssertEqual(expectedObject!.radius, 10)
        XCTAssertEqual(expectedObject!.longitude, 15)
        XCTAssertEqual(expectedObject!.latitude, 33)
    }

    func test_fetchObject_returnsObjectWhenRequestValid() {
        let createdObject = createLocatic()
        sut.fetchObject(entity: Locatic.self, identity: createdObject.identity) { (object) in
            XCTAssertNotNil(object)
            XCTAssertEqual(object, createdObject)
        }
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
        _ = createLocatic()
        _ = createLocatic()
        _ = createLocatic()

        sut.fetchObjects(entity: Locatic.self, predicate: nil, sortDescriptors: nil) { (result) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success.count, 3)
            case .failure(let failure):
                XCTFail("Should not fail - \(failure.localizedDescription)")
            }
        }
    }

    func test_fetchObjects_returnsCorrectAmountWithPredicate() {
        let coreDataObject = createLocatic()
        _ = createLocatic()
        _ = createLocatic()

        let predicate = NSPredicate(format: "\(#keyPath(DB_LocalItem.identity)) == %ld", coreDataObject.identity)

        sut.fetchObjects(entity: Locatic.self, predicate: predicate, sortDescriptors: nil) { (result) in
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
        let coreDataObject = createLocatic(withValues: ["name": "MyNewName"])

        sut.updateObject(entity: Locatic.self, identity: coreDataObject.identity, updatedValues: [:]) { (result) in
            switch result {
            case .success(let success):
                XCTAssertEqual(success, coreDataObject)
                XCTAssertEqual(success.name, "MyNewName")
            case .failure(let failure):
                XCTFail("Should be able to find object by it's identity - \(failure.localizedDescription)")
            }
        }
    }

    func test_updateObject_completesWithErrorWhenPassedInvalidID() {
        _ = createLocatic()

        sut.updateObject(entity: Locatic.self, identity: 0, updatedValues: [:]) { (result) in
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
        let coreDataObject = createLocatic()

        let expect = expectation(description: "Wait for moc perform changes")

        sut.deleteObject(entity: Locatic.self, identity: coreDataObject.identity) { (error) in
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
        _ = createLocatic()

        sut.deleteObject(entity: Locatic.self, identity: 0) { (error) in
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
    func createLocatic(withValues values: [String: Any] = ["name": "name",
                                                           "radius": 0,
                                                           "longitude": 0,
                                                           "latitude": 0]) -> Locatic {
        let moc = mockPC.viewContext
        var coreDataObject: Locatic?

        let expect = expectation(description: "Wait for moc perform changes")

        sut.createObject(entity: Locatic.self, values: values) { (result) in
            switch result {
            case .success(let success):
                coreDataObject = success

                XCTAssertEqual(moc.insertedObjects.count, 1)
                expect.fulfill()
            case .failure(let failure):
                XCTFail("Should not fail - \(failure.localizedDescription)")
            }
        }

        wait(for: [expect], timeout: 3)

        XCTAssertNotNil(coreDataObject)
        XCTAssertEqual(moc.insertedObjects.count, 0)

        return coreDataObject!
    }
}
