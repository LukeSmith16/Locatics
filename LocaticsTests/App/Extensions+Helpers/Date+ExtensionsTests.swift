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
    func test_startOfWeek_isMidnightMonday() {
        let calendar = Calendar.current

        let fixedDateComps = DateComponents(calendar: calendar,
                                            timeZone: TimeZone.current,
                                            era: nil,
                                            year: 2019,
                                            month: 10,
                                            day: 30,
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
        let fixedDate = calendar.date(from: fixedDateComps)!

        let startOfWeekForFixedDateComps = DateComponents(calendar: calendar,
                                                          timeZone: TimeZone.current,
                                                          era: nil,
                                                          year: 2019,
                                                          month: 10,
                                                          day: 28,
                                                          hour: 00,
                                                          minute: 00,
                                                          second: 00,
                                                          nanosecond: 00,
                                                          weekday: nil,
                                                          weekdayOrdinal: nil,
                                                          quarter: nil,
                                                          weekOfMonth: nil,
                                                          weekOfYear: nil,
                                                          yearForWeekOfYear: nil)
        let startOfWeekForFixedDate = calendar.date(from: startOfWeekForFixedDateComps)!

        XCTAssertEqual(fixedDate.startOfWeek, startOfWeekForFixedDate)
    }}
