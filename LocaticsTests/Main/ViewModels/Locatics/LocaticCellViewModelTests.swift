//
//  LocaticCellViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticCellViewModelTests: XCTestCase {

    var sut: LocaticCellViewModel!

    override func setUp() {
        sut = LocaticCellViewModel(locatic: MockLocatic())
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_locatic_isNotNil() {
        XCTAssertNotNil(sut.locatic)
    }

    func test_hoursSpentThisWeek_isNotNil() {
        XCTAssertNotNil(sut.hoursSpentThisWeek)
    }

    func test_locaticChartViewModel_isNotNil() {
        XCTAssertNotNil(sut.locaticChartViewModel)
    }

    func test_setupLocaticVisits_onlyUsesVisitsForThisWeek() {
        let mockLocatic = MockLocatic()
        mockLocatic.locaticVisits = NSOrderedSet(array: setupMockVisits())

        sut = LocaticCellViewModel(locatic: mockLocatic)

        let dataEntryMatchingVisit = sut.locaticChartViewModel.locaticChartDataEntries.first {$0.entryValue != 0.0}

        XCTAssertNotNil(dataEntryMatchingVisit)

        XCTAssertTrue(Calendar.current.isDateInThisWeek(dataEntryMatchingVisit!.entryDate))
        XCTAssertEqual(dataEntryMatchingVisit!.entryValue!, 1)
    }

    func test_setupLocaticVisits_setsHoursSpentThisWeek() {
        let mockLocatic = MockLocatic()
        mockLocatic.locaticVisits = NSOrderedSet(array: setupMockVisits())

        sut = LocaticCellViewModel(locatic: mockLocatic)

        XCTAssertEqual(sut.hoursSpentThisWeek, "1 HOURS THIS WEEK")
    }

    func test_setupLocaticVisits_setsLocaticChartViewModel() {
        let mockLocatic = MockLocatic()
        mockLocatic.locaticVisits = NSOrderedSet(array: setupMockVisits())

        sut = LocaticCellViewModel(locatic: mockLocatic)

        let dataEntriesMatchingVisit = sut.locaticChartViewModel.locaticChartDataEntries.filter {$0.entryValue != 0.0}

        XCTAssertEqual(dataEntriesMatchingVisit.count, 1)
    }

    func test_setupLocaticVisits_setsLocaticChartViewModelWhenVisitExitDateNotMatchingThisWeek() {
        let visitInThisWeek = MockLocaticVisit()
        visitInThisWeek.exitDate = Date().addingTimeInterval((3600 * 24) * 10)

        let mockLocatic = MockLocatic()
        mockLocatic.locaticVisits = NSOrderedSet(array: [visitInThisWeek])

        sut = LocaticCellViewModel(locatic: mockLocatic)

        let dataEntryMatchingVisit = sut.locaticChartViewModel.locaticChartDataEntries.first {$0.entryValue != 0.0}

        XCTAssertNotNil(dataEntryMatchingVisit)
    }
}

private extension LocaticCellViewModelTests {
    func setupMockVisits() -> [MockLocaticVisit] {
        let visitInThisWeek = MockLocaticVisit()
        visitInThisWeek.exitDate = Date().addingTimeInterval(3600)

        let visitOutsideOfThisWeek = MockLocaticVisit()
        visitOutsideOfThisWeek.entryDate = Date().startOfWeek.addingTimeInterval(-5000)
        visitOutsideOfThisWeek.exitDate = Date().startOfWeek.addingTimeInterval(-4000)

        return [visitInThisWeek, visitOutsideOfThisWeek]
    }
}
