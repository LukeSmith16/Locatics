//
//  AddLocaticViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 15/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol AddLocaticViewModelInterface: class {
    var viewDelegate: AddLocaticViewModelViewDelegate? {get set}

    func radiusDidChange(_ newValue: Float)
    func addLocaticWasTapped(locaticName: String?, radius: Float)
}

protocol AddLocaticViewModelViewDelegate: class {
    func changeRadiusText(_ newRadiusText: String)
}

protocol LocaticEntryValidationDelegate: class {
    func validationErrorOccured(_ error: String)
}

protocol LocaticPinLocationDelegate: class {
    func getPinCurrentLocationCoordinate() -> Coordinate
}

enum AddLocaticEntryValidation: Error {
    case noNameEntered
    case radiusTooSmall
}

extension AddLocaticEntryValidation: LocalizedError {
    var errorDescription: String? {
        switch self {
        case .noNameEntered:
            return "Please give your Locatic a name."
        case .radiusTooSmall:
            return "Please specify a larger radius for your locatic."
        }
    }
}

class AddLocaticViewModel: AddLocaticViewModelInterface {
    weak var viewDelegate: AddLocaticViewModelViewDelegate?
    weak var locaticEntryValidationDelegate: LocaticEntryValidationDelegate?
    weak var locaticPinLocationDelegate: LocaticPinLocationDelegate?

    private let locaticStorage: LocaticStorageInterface

    init(locaticStorage: LocaticStorageInterface) {
        self.locaticStorage = locaticStorage
    }

    func radiusDidChange(_ newValue: Float) {
        let valueToInt = Int(newValue)
        let newRadiusText = "Radius: \(valueToInt) meters"
        viewDelegate?.changeRadiusText(newRadiusText)
    }

    func addLocaticWasTapped(locaticName: String?,
                             radius: Float) {
        guard isNewLocaticValuesValid(name: locaticName, radius: radius),
            let pinLocation = locaticPinLocationDelegate?.getPinCurrentLocationCoordinate() else { return }

        locaticStorage.insertLocatic(name: locaticName!,
                                     radius: radius,
                                     longitude: pinLocation.longitude,
                                     latitude: pinLocation.latitude) { [weak self] (error) in
                                        if let error = error {
                                            self?.locaticEntryValidationDelegate?.validationErrorOccured(error.localizedDescription)
                                        } else {
                                            // Do animations, inform parent VM of locatic being added etc.
                                        }
        }
    }
}

extension AddLocaticViewModel {
    func isNewLocaticValuesValid(name: String?, radius: Float) -> Bool {
        do {
            try validateLocaticName(name)
            try validateLocaticRadius(radius)

            return true
        } catch {
            locaticEntryValidationDelegate?.validationErrorOccured(error.localizedDescription)

            return false
        }
    }

    func validateLocaticName(_ name: String?) throws {
        guard let name = name, !name.isEmpty else {
            throw AddLocaticEntryValidation.noNameEntered
        }
    }

    func validateLocaticRadius(_ radius: Float) throws {
        guard radius > 10 else {
            throw AddLocaticEntryValidation.radiusTooSmall
        }
    }
}
