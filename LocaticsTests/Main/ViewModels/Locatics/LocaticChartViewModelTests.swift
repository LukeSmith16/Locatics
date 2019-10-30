//
//  LocaticChartViewModelTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 27/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class LocaticChartViewModelTests: XCTestCase {

    var sut: LocaticChartViewModel!

    override func setUp() {
        sut = LocaticChartViewModel()
    }

    override func tearDown() {
        sut = nil
        super.tearDown()
    }

    func test_locaticVisits_isEmpty() {
        XCTAssertTrue(sut.locaticVisits.isEmpty)
    }

    func test_locaticChartDataEntries_isEmpty() {
        XCTAssertTrue(sut.locaticChartDataEntries.isEmpty)
    }

    func test_dateFormatter_dateFormatIsE() {
        XCTAssertEqual(sut.dateFormatter.dateFormat,
                       "E")
    }

    func test_dataEntriesCount_isEqualToLocaticChartDataEntriesCount() {
        XCTAssertEqual(sut.dataEntriesCount(),
                       sut.locaticVisits.count)
    }

    func test_setupLocaticChartDataEntries_setsLocaticChartDataEntriesToSeven() {
        let mockVisit = MockLocaticVisit()
        mockVisit.exitDate = Date()

        sut.locaticVisits = [mockVisit]

        XCTAssertEqual(sut.locaticChartDataEntries.count, 7)
    }

    func test_setupLocaticChartDataEntries_formatsDataEntryFromVisit() {
        let mockVisit = MockLocaticVisit()
        mockVisit.exitDate = Date().addingTimeInterval(3600)

        sut.locaticVisits = [mockVisit]

        let visitDataEntries = sut.locaticChartDataEntries.filter { (dataEntry) -> Bool in
            return dataEntry.entryValue != 0.0
        }

        XCTAssertEqual(visitDataEntries.first!.entryValue!, 1)
    }

    func test_locaticChartDataEntries_allDaysAreInThisWeek() {
        let mockVisit = MockLocaticVisit()
        mockVisit.exitDate = Date()

        sut.locaticVisits = [mockVisit]

        for visitDataEntry in sut.locaticChartDataEntries {
            XCTAssertTrue(Calendar.current.isDateInThisWeek(visitDataEntry.entryDate))
        }
    }

    func test_timeDifferenceFromFutureDate_formatsChartDataEntry() {
        let mockVisit = MockLocaticVisit()
        mockVisit.exitDate = Date().addingTimeInterval(3600 * 25)

        sut.locaticVisits = [mockVisit]

        let visitDataEntry = sut.locaticChartDataEntries.first { (dataEntry) -> Bool in
            return dataEntry.entryValue != 0.0
            }!

        let calendar = Calendar.current
        let tomorrow = calendar.date(bySettingHour: 23, minute: 59, second: 00, of: Date())!
        let components = calendar.dateComponents([.minute], from: mockVisit.entryDate, to: tomorrow)

        XCTAssertEqual(visitDataEntry.entryValue!, Double((components.minute! / 60)))
    }

    func test_timeDifferenceFromPastDate_formatsChartDataEntry() {
        let calendar = Calendar.current

        let lunchtimeToday = calendar.date(bySettingHour: 12, minute: 00, second: 00, of: Date())!

        let mockVisit = MockLocaticVisit()
        mockVisit.entryDate = Date().addingTimeInterval(-3600 * 26)
        mockVisit.exitDate = lunchtimeToday

        sut.locaticVisits = [mockVisit]

        let visitDataEntry = sut.locaticChartDataEntries.first { (dataEntry) -> Bool in
            return dataEntry.entryValue == 11.0
        }

        XCTAssertNotNil(visitDataEntry)
    }
}
