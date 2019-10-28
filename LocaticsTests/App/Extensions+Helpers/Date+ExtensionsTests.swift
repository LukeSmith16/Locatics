//
//  Date+ExtensionsTests.swift
//  LocaticsTests
//
//  Created by Luke Smith on 27/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import XCTest

@testable import Locatics
class DateExtensionsTests: XCTestCase {
    func test_startOfWeek_withDaylightSavingTimeReturnsBeginningOfWeek() {
        let calendar = Calendar.current

        let daylightSavingComps = DateComponents(calendar: calendar,
                                                 timeZone: TimeZone.current,
                                                 era: nil,
                                                 year: 2019,
                                                 month: 8,
                                                 day: 5,
                                                 hour: 10,
                                                 minute: 10,
                                                 second: 10,
                                                 nanosecond: 10,
                                                 weekday: 1,
                                                 weekdayOrdinal: 1,
                                                 quarter: nil,
                                                 weekOfMonth: nil,
                                                 weekOfYear: nil,
                                                 yearForWeekOfYear: nil)
        let daylightSavingDate = calendar.date(from: daylightSavingComps)!

        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                                 from: daylightSavingDate))!
        XCTAssertEqual(daylightSavingDate.startOfWeek,
                       calendar.date(byAdding: .day, value: 1, to: sunday)!)
    }

    func test_startOfWeek_withoutDaylightSavingTimeReturnsBeginningOfWeek() {
        let calendar = Calendar.current

        let daylightSavingComps = DateComponents(calendar: calendar,
                                                 timeZone: TimeZone.current,
                                                 era: nil,
                                                 year: 2019,
                                                 month: 11,
                                                 day: 5,
                                                 hour: 10,
                                                 minute: 10,
                                                 second: 10,
                                                 nanosecond: 10,
                                                 weekday: 1,
                                                 weekdayOrdinal: 1,
                                                 quarter: nil,
                                                 weekOfMonth: nil,
                                                 weekOfYear: nil,
                                                 yearForWeekOfYear: nil)
        let daylightSavingDate = calendar.date(from: daylightSavingComps)!

        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear],
                                                                 from: daylightSavingDate))!
        XCTAssertEqual(daylightSavingDate.startOfWeek,
                       calendar.date(byAdding: .day, value: 1, to: sunday)!.addingTimeInterval(3600))
    }
}
