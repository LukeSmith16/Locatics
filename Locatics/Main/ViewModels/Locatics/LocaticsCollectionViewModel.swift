//
//  LocaticsCollectionViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import Foundation

protocol LocaticsCollectionViewModelInterface {
    var viewDelegate: LocaticsCollectionViewModelViewDelegate? {get set}

    func locaticsCount() -> Int
}

protocol LocaticsCollectionViewModelViewDelegate: class {

}

class LocaticsCollectionViewModel: LocaticsCollectionViewModelInterface {
    weak var viewDelegate: LocaticsCollectionViewModelViewDelegate?

    func locaticsCount() -> Int {
        return 0
    }
}
