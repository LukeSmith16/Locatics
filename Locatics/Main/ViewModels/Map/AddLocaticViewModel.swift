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
    func locaticIconDidChange(_ tag: Int)
    func addLocaticWasTapped(locaticName: String?, radius: Float)
}

protocol AddLocaticViewModelViewDelegate: class {
    func changeRadiusText(_ newRadiusText: String)
}

protocol LocaticEntryValidationDelegate: class {
    func validationErrorOccured(_ error: String)
    func closeAddLocaticCardView()
}

protocol LocaticPinLocationDelegate: LocaticsMainLocationPinCoordinateDelegate {
    func updatePinAnnotationRadius(toRadius radius: Double)
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
    private var locaticIconPath: String = "defaultPath"

    init(locaticStorage: LocaticStorageInterface) {
        self.locaticStorage = locaticStorage
    }

    func radiusDidChange(_ newValue: Float) {
        let valueToInt = Int(newValue)
        let newRadiusText = "Radius: \(valueToInt) meters"
        viewDelegate?.changeRadiusText(newRadiusText)
        locaticPinLocationDelegate?.updatePinAnnotationRadius(toRadius: Double(newValue))
    }

    func locaticIconDidChange(_ tag: Int) {
        switch tag {
        case 0:
            self.locaticIconPath = "addLocaticButtonIcon"
        case 1:
            self.locaticIconPath = "test"
        default:
            break
        }
    }

    func addLocaticWasTapped(locaticName: String?,
                             radius: Float) {
        guard isNewLocaticValuesValid(name: locaticName, radius: radius),
            let pinLocation = locaticPinLocationDelegate?.getPinCurrentLocationCoordinate() else { return }

        locaticStorage.insertLocatic(name: locaticName!,
                                     radius: radius,
                                     longitude: pinLocation.longitude,
                                     latitude: pinLocation.latitude,
                                     iconPath: locaticIconPath) { [weak self] (error) in
                                        if let errorDesc = error?.localizedDescription {
                                            self?.locaticEntryValidationDelegate?.validationErrorOccured(errorDesc)
                                        } else {
                                            self?.locaticEntryValidationDelegate?.closeAddLocaticCardView()
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
