//
//  DateFormatterManager.swift
//  Locatics
//
//  Created by Luke Smith on 09/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

struct DateFormatterManager {
    static let shared = DateFormatterManager()

    private static let hoursMinutesDateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.dateFormat = "h:mm a"

        return formatter
    }()

    private init() {}

    static func hoursMinutes(from date: Date) -> String {
        return hoursMinutesDateFormatter.string(from: date)
    }
}
