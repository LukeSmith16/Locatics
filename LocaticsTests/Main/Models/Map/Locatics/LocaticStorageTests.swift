//
//  LocaticStorageTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 29/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest
import CoreData

//swiftlint:disable force_cast

@testable import Locatics
class LocaticStorageTests: XCTestCase {

    var sut: LocaticStorage!

    private var mockStorageManager: MockStorageManager!
    private var mockLocaticPersistentStorageObserver: MockLocaticPersistentStorageDelegate!

    override func setUp() {
        mockStorageManager = MockStorageManager()
        mockLocaticPersistentStorageObserver = MockLocaticPersistentStorageDelegate()

        sut = LocaticStorage(storageManager: mockStorageManager)
        sut.persistentStorageObserver.add(mockLocaticPersistentStorageObserver)
    }

    override func tearDown() {
        sut.persistentStorageObserver.remove(mockLocaticPersistentStorageObserver)
        sut = nil
        mockStorageManager = nil
        mockLocaticPersistentStorageObserver = nil
        super.tearDown()
    }

    func test_fetchLocatics_callsFetchObjects() {
        sut.fetchLocatics(predicate: nil, sortDescriptors: nil) { (_) in
            XCTAssertTrue(self.mockStorageManager.calledFetchObjects)
        }
    }

    func test_insertLocatic_callsCreateObject() {
        sut.insertLocatic(name: "", radius: 0.0, longitude: 0.0, latitude: 0.0, completion: { (error) in
            XCTAssertNil(error)
        })

        XCTAssertTrue(mockStorageManager.calledCreateObject)
    }

    func test_deleteLocatic_callsDeleteObject() {
        sut.deleteLocatic(MockLocatic()) { (_) in
            XCTAssertTrue(self.mockStorageManager.calledDeleteObject)
        }
    }

    func test_insertLocatic_callsLocaticWasInserted() {
        sut.insertLocatic(name: "myNewLocatic", radius: 14.5, longitude: 33, latitude: 51, completion: { (error) in
            XCTAssertNil(error)
        })

        XCTAssertTrue(mockLocaticPersistentStorageObserver.calledLocaticWasInserted)
    }

    func test_insertLocatic_passesCorrectValuesToStorageManager() {
        sut.insertLocatic(name: "myNewLocatic", radius: 14.5, longitude: 33, latitude: 51, completion: { (error) in
            XCTAssertNil(error)
        })

        let passedValues = mockStorageManager.passedCreateObjectValues
        XCTAssertEqual(passedValues["name"] as! String,
                       "myNewLocatic")
        XCTAssertEqual(passedValues["radius"] as! Float,
                       14.5)
        XCTAssertEqual(passedValues["longitude"] as! Double,
                       33)
        XCTAssertEqual(passedValues["latitude"] as! Double,
                       51)
    }

    func test_insertLocatic_completesWithError() {
        mockStorageManager.shouldFail = true

        sut.insertLocatic(name: "", radius: 0.0, longitude: 0.0, latitude: 0.0) { (error) in
            XCTAssertNotNil(error)
            XCTAssertTrue(error! == .badRequest)
        }
    }

    func test_updateLocatic_callsLocaticWasUpdated() {
        let mockLocatic = MockLocatic()
        mockLocatic.identity = 50

        let expect = expectation(description: "Wait for deletion")

        sut.updateLocatic(locatic: mockLocatic, name: "newName", radius: 60, longitude: 18, latitude: 20.0) { (_) in
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        XCTAssertTrue(mockLocaticPersistentStorageObserver.calledLocaticWasUpdated)
    }

    func test_updateLocatic_passesCorrectValuesToStorageManager() {
        let mockLocatic = MockLocatic()
        mockLocatic.identity = 50

        let expect = expectation(description: "Wait for deletion")

        sut.updateLocatic(locatic: mockLocatic,
                          name: "myUpdatedLocatic",
                          radius: 10,
                          longitude: 99,
                          latitude: 98) { (_) in
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        let passedValues = mockStorageManager.passedUpdateObjectValues
        XCTAssertEqual(passedValues["name"] as! String,
                       "myUpdatedLocatic")
        XCTAssertEqual(passedValues["radius"] as! Float,
                       10)
        XCTAssertEqual(passedValues["longitude"] as! Double,
                       99)
        XCTAssertEqual(passedValues["latitude"] as! Double,
                       98)
    }

    func test_deleteLocatic_callsLocaticWasDeleted() {
        let mockLocatic = MockLocatic()
        mockLocatic.identity = 50

        let expect = expectation(description: "Wait for deletion")

        sut.deleteLocatic(mockLocatic) { (_) in
            expect.fulfill()
        }

        wait(for: [expect], timeout: 2)

        XCTAssertTrue(mockLocaticPersistentStorageObserver.calledLocaticWasDeleted)
        XCTAssertEqual(mockLocaticPersistentStorageObserver.deletedValue!.identity,
                       mockLocatic.identity)
    }

    func test_fetchLocatics_handlesErrorCase() {
        mockStorageManager.shouldFail = true
        sut.fetchLocatics(predicate: nil, sortDescriptors: nil) { (result) in
            switch result {
            case .success(let success):
                XCTFail("Should not succeed if there is error - \(success)")
            case .failure(let failure):
                XCTAssertTrue(failure == .badRequest)
            }
        }
    }

    func test_updateLocatic_handlesErrorCase() {
        mockStorageManager.shouldFail = true
        sut.updateLocatic(locatic: MockLocatic(), name: "", radius: 20.0, longitude: 10.0, latitude: 0.0) { (error) in
            XCTAssertNotNil(error)
            XCTAssertTrue(error! == .badRequest)
        }
    }

    func test_deleteLocatic_handlesErrorCase() {
        mockStorageManager.shouldFail = true
        sut.deleteLocatic(MockLocatic()) { (error) in
            XCTAssertNotNil(error)
            XCTAssertTrue(error! == .badRequest)
        }
    }
}

private extension LocaticStorageTests {
    class MockLocatic: LocaticData {
        var identity: Int64 = 0

        var name: String = "TestLocatic"
        var radius: Float = 50 // Meters
        var longitude: Double = 12.0
        var latitude: Double = 10.0
    }

    class MockLocaticPersistentStorageDelegate: LocaticPersistentStorageDelegate {
        var calledLocaticWasInserted = false
        var calledLocaticWasUpdated = false
        var calledLocaticWasDeleted = false

        var insertedValue: LocaticData?
        func locaticWasInserted(_ insertedLocatic: LocaticData) {
            insertedValue = insertedLocatic
            calledLocaticWasInserted = true
        }

        var updatedValue: LocaticData?
        func locaticWasUpdated(_ updatedLocatic: LocaticData) {
            updatedValue = updatedLocatic
            calledLocaticWasUpdated = true
        }

        var deletedValue: LocaticData?
        func locaticWasDeleted(_ deletedLocatic: LocaticData) {
            deletedValue = deletedLocatic
            calledLocaticWasDeleted = true
        }
    }
}
