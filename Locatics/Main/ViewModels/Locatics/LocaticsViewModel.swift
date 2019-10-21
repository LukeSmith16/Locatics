//
//  LocaticsViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticsViewModelInterface {
    var viewDelegate: LocaticsViewModelViewDelegate? {get set}
}

protocol LocaticsViewModelViewDelegate: class {

}

class LocaticsViewModel: LocaticsViewModelInterface {
    weak var viewDelegate: LocaticsViewModelViewDelegate?
}
