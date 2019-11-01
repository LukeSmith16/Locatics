//
//  LocaticChartViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 24/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticChartViewModelInterface {
    var locaticChartDataEntries: [LocaticChartDataEntryInterface] {get}
    var dateFormatter: DateFormatter {get}

    func dataEntriesCount() -> Int
}

class LocaticChartViewModel: LocaticChartViewModelInterface {
    var locaticChartDataEntries: [LocaticChartDataEntryInterface] = []
    var locaticVisits: [LocaticVisitData] = [] {
        didSet {
            setupLocaticChartDataEntries()
        }
    }

    var dateFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E"
        return dateFormatter
    }()

    private let calendar = Calendar.current

    func dataEntriesCount() -> Int {
        return locaticChartDataEntries.count
    }
}

private extension LocaticChartViewModel {
    func setupLocaticChartDataEntries() {
        let startOfTheWeek = Date().startOfWeek

        for day in 0...6 {
            let dateFromDayValue = calendar.date(byAdding: .day, value: day, to: startOfTheWeek)!
            let locaticVisitsMatchingDay = getLocaticVisitsMatchingDay(day: day, dateFromDayValue: dateFromDayValue)

            let minutesSpentOnThisDay = getMinutesSpentFromDay(visitsMatchingDay: locaticVisitsMatchingDay,
                                                               dateFromDayValue: dateFromDayValue)

            let hoursSpentOnThisDay = calculateHoursFromMinutes(minutesSpentOnThisDay)

            let locaticChartDataEntry = LocaticChartDataEntry(entryDate: dateFromDayValue,
                                                              entryValue: hoursSpentOnThisDay)
            self.locaticChartDataEntries.append(locaticChartDataEntry)
        }
    }

    func getLocaticVisitsMatchingDay(day: Int, dateFromDayValue: Date) -> [LocaticVisitData] {
        return locaticVisits.filter { (locaticVisit) -> Bool in
            let entryDateMatchingDay = calendar.isDate(locaticVisit.entryDate, inSameDayAs: dateFromDayValue)
            let exitDateMatchingDay = calendar.isDate(locaticVisit.exitDate!, inSameDayAs: dateFromDayValue)

            return entryDateMatchingDay || exitDateMatchingDay
        }
    }

    func getMinutesSpentFromDay(visitsMatchingDay: [LocaticVisitData], dateFromDayValue: Date) -> Int {
        var minutesSpent = 0

        for visit in visitsMatchingDay {
            let entryDateMatchingDay = calendar.isDate(visit.entryDate, inSameDayAs: dateFromDayValue)
            let exitDateMatchingDay = calendar.isDate(visit.exitDate!, inSameDayAs: dateFromDayValue)

            if entryDateMatchingDay && exitDateMatchingDay {
                minutesSpent += timeDifferenceFromDatesInToday(entryDate: visit.entryDate,
                                                               exitDate: visit.exitDate!)
            } else if entryDateMatchingDay && !exitDateMatchingDay {
                minutesSpent += timeDifferenceFromFutureDate(entryDate: visit.entryDate,
                                                             futureDateFrom: dateFromDayValue)
            } else if !entryDateMatchingDay && exitDateMatchingDay {
                minutesSpent += timeDifferenceFromPastDate(exitDate: visit.exitDate!,
                                                           pastDateFrom: dateFromDayValue)
            }
        }

        return minutesSpent
    }

    func timeDifferenceFromDatesInToday(entryDate: Date, exitDate: Date) -> Int {
        let components = calendar.dateComponents([.minute], from: entryDate, to: exitDate)
        return components.minute!
    }

    func timeDifferenceFromFutureDate(entryDate: Date, futureDateFrom: Date) -> Int {
        let tomorrow = calendar.date(bySettingHour: 23, minute: 59, second: 00, of: futureDateFrom)!
        let components = calendar.dateComponents([.minute], from: entryDate, to: tomorrow)

        return components.minute!
    }

    func timeDifferenceFromPastDate(exitDate: Date, pastDateFrom: Date) -> Int {
        let yesterday = calendar.date(bySettingHour: 00, minute: 00, second: 01, of: pastDateFrom)!
        let components = calendar.dateComponents([.minute], from: yesterday, to: exitDate)

        return components.minute!
    }

    func calculateHoursFromMinutes(_ minutes: Int) -> Double {
        return Double(minutes / 60)
    }
}
