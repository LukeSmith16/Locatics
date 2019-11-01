//
//  LocaticChartXAxisDateFormatter.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Charts

class LocaticChartXAxisDateFormatter: NSObject {
    private var dateFormatter: DateFormatter!

    convenience init(dateFormatter: DateFormatter) {
        self.init()
        self.dateFormatter = dateFormatter
    }
}

extension LocaticChartXAxisDateFormatter: IAxisValueFormatter {
    func stringForValue(_ value: Double, axis: AxisBase?) -> String {
        let date = Date(timeIntervalSince1970: value)
        return dateFormatter.string(from: date).uppercased()
    }
}
