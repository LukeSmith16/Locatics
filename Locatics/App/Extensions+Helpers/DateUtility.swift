//
//  DateUtility.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable identifier_name

import Foundation

struct DateUtility {
    private let calendar = Calendar.current

    func differenceInHours(from: Date, to: Date) -> Decimal {
        let components = calendar.dateComponents([.minute], from: from, to: to)
        let minutesDifference = components.minute!

        return Decimal(minutesDifference / 60)
    }
}
