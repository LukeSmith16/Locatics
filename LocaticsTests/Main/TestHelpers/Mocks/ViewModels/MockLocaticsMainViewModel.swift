//
//  MockLocaticsMainViewModel.swift
//  LocaticsTests
//
//  Created by Luke Smith on 10/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

@testable import Locatics
class MockLocaticsMainViewModel: LocaticsMainViewModelInterface {

    var calledGetRecentLocation = false
    var calledAddLocaticWasTapped = false
    var calledCloseLocaticCardViewWasTapped = false

    weak var viewDelegate: LocaticsMainViewModelViewDelegate?
    weak var addLocaticViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate?

    var addLocaticViewModel: AddLocaticViewModelInterface? {
        return AddLocaticViewModel(locaticStorage: MockLocaticStorage())
    }

    var locaticsMapViewModel: LocaticsMapViewModelInterface? {
        return LocaticsMapViewModel(locaticStorage: MockLocaticStorage())
    }

    func getRecentLocation() {
        calledGetRecentLocation = true
    }

    func addLocaticWasTapped() {
        calledAddLocaticWasTapped = true
    }

    func closeLocaticCardViewWasTapped() {
        calledCloseLocaticCardViewWasTapped = true
    }
}
