//
//  LocaticCellViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticCellViewModelInterface {
    var locatic: LocaticData {get}
    var hoursSpentThisWeek: String! {get}
    var locaticChartViewModel: LocaticChartViewModelInterface! {get}
}

class LocaticCellViewModel: LocaticCellViewModelInterface {
    let locatic: LocaticData
    var hoursSpentThisWeek: String!
    var locaticChartViewModel: LocaticChartViewModelInterface!

    init(locatic: LocaticData) {
        self.locatic = locatic
        setupLocaticVisits()
    }
}

private extension LocaticCellViewModel {
    func setupLocaticVisits() {
        guard let locaticVisits = locatic.locaticVisits?.array as? [LocaticVisitData] else { return }
        let locaticVisitsThisWeek = locaticVisits.filter { (visit) -> Bool in
            guard let exitDate = visit.exitDate else { return false }
            let entryDateMatchingWeek = Calendar.current.isDateInThisWeek(visit.entryDate)
            let exitDateMatchingWeek = Calendar.current.isDateInThisWeek(exitDate)

            return entryDateMatchingWeek || exitDateMatchingWeek
        }

        setupHoursSpentThisWeek(from: locaticVisitsThisWeek)
        setupLocaticChartViewModel(with: locaticVisitsThisWeek)
    }

    func setupHoursSpentThisWeek(from visits: [LocaticVisitData]) {
        var hoursSpentThisWeek: Decimal = 0.0

        let dateUtility = DateUtility()
        for visit in visits {
            let differenceInHours = dateUtility.differenceInHours(from: visit.entryDate,
                                                                  to: visit.exitDate!)
            hoursSpentThisWeek += differenceInHours
        }

        self.hoursSpentThisWeek = "\(hoursSpentThisWeek) HOURS THIS WEEK"
    }

    func setupLocaticChartViewModel(with visits: [LocaticVisitData]) {
        let locaticChartViewModel = LocaticChartViewModel()
        locaticChartViewModel.locaticVisits = visits

        self.locaticChartViewModel = locaticChartViewModel
    }
}
