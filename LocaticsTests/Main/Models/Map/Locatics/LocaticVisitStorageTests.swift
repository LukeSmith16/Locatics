//
//  LocaticVisitStorageTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 11/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

//swiftlint:disable force_cast

import XCTest
import CoreData

@testable import Locatics
class LocaticVisitStorageTests: XCTestCase {

    var sut: LocaticVisitStorage!

    private var mockStorageManager: MockStorageManager!

    override func setUp() {
        mockStorageManager = MockStorageManager()
        sut = LocaticVisitStorage(storageManager: mockStorageManager)
    }

    override func tearDown() {
        sut = nil
        mockStorageManager = nil
        super.tearDown()
    }

    func test_insertLocaticVisit_callsCreateObject() {
        let locatic = Locatic()
        sut.insertLocaticVisit(entryDate: Date(),
                               locatic: locatic) { (error) in
                                XCTAssertNil(error)
        }

        XCTAssertTrue(self.mockStorageManager.calledCreateObject)
    }

    func test_insertLocaticVisit_passesChangedValuesToCreateObject() {
        let locatic = Locatic()
        let date = Date()
        sut.insertLocaticVisit(entryDate: date,
                               locatic: locatic) { (error) in
                                XCTAssertNil(error)
        }

        XCTAssertEqual(mockStorageManager.passedCreateObjectValues["entryDate"] as! Date,
                       date)
        XCTAssertNotNil(mockStorageManager.passedCreateObjectValues["locatic"])
    }

    func test_insertLocaticVisit_completesWithError() {
        mockStorageManager.shouldFail = true

        let locatic = Locatic()
        sut.insertLocaticVisit(entryDate: Date(),
                               locatic: locatic) { (error) in
                                XCTAssertNotNil(error)
                                XCTAssertTrue(error! == .badRequest)
        }
    }

    func test_insertLocaticVisit_hasFatalErrorIfConcreteTypeIsNotLocatic() {
        expectFatalError(expectedMessage: "Locatic should be on concrete type 'Locatic'") {
            self.sut.insertLocaticVisit(entryDate: Date(),
                                   locatic: MockLocatic()) { (_) in
                                    return
            }
        }
    }

    func test_updateLocaticVisit_callsUpdateObject() {
        let locaticVisit = MockLocaticVisit()
        sut.updateLocaticVisit(locaticVisit: locaticVisit,
                               exitDate: Date()) { (error) in
                                XCTAssertNil(error)
        }

        XCTAssertTrue(mockStorageManager.calledUpdateObject)
    }

    func test_updateLocaticVisit_passesChangedValuesToUpdateObject() {
        let locaticVisit = MockLocaticVisit()
        let date = Date()
        sut.updateLocaticVisit(locaticVisit: locaticVisit,
                               exitDate: date) { (error) in
                                XCTAssertNil(error)
        }

        XCTAssertEqual(mockStorageManager.passedUpdateObjectValues["exitDate"] as! Date,
                       date)
    }

    func test_updateLocaticVisit_completesWithError() {
        mockStorageManager.shouldFail = true

        let locaticVisit = MockLocaticVisit()
        sut.updateLocaticVisit(locaticVisit: locaticVisit,
                               exitDate: Date()) { (error) in
                                XCTAssertNotNil(error)
                                XCTAssertTrue(error! == .badRequest)
        }
    }
}
