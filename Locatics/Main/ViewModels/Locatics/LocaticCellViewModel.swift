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
}

class LocaticCellViewModel: LocaticCellViewModelInterface {
    let locatic: LocaticData

    init(locatic: LocaticData) {
        self.locatic = locatic
    }
}
