//
//  Date+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

extension Date {
    var startOfWeek: Date {
        let calendar = Calendar.current
        let sunday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!

        if TimeZone.current.isDaylightSavingTime(for: self) {
            return calendar.date(byAdding: .day, value: 1, to: sunday)!
        } else {
            return calendar.date(byAdding: .day, value: 1, to: sunday)!.addingTimeInterval(3600)
        }
    }
}
