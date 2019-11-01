//
//  Calendar+Extensions.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

extension Calendar {
    private var currentDate: Date {
        return Date()
    }

    func isDateInThisWeek(_ date: Date) -> Bool {
        return isDate(date, equalTo: currentDate, toGranularity: .weekOfYear)
    }
}
