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
        let gregorian = Calendar(identifier: .gregorian)
        let sunday = gregorian.date(from: gregorian.dateComponents([.yearForWeekOfYear, .weekOfYear], from: self))!

        return gregorian.date(byAdding: .day, value: -6, to: sunday)!
    }
}
