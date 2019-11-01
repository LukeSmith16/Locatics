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
        let monday = calendar.date(from: calendar.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!

        return monday
    }
}
