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

enum AddLocaticEntryValidation: Error {
    case noNameEntered
    case radiusTooSmall

    var localizedDescription: String {
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

    func radiusDidChange(_ newValue: Float) {
        let valueToInt = Int(newValue)
        let newRadiusText = "Radius: \(valueToInt) meters"
        viewDelegate?.changeRadiusText(newRadiusText)
    }

    func addLocaticWasTapped(locaticName: String?, radius: Float) {
        guard isNewLocaticValuesValid(name: locaticName, radius: radius) else { return }
        // TODO: Think about how DB layer is going to be setup?
    }
}

extension AddLocaticViewModel {
    // TODO: Add testing here.
    func isNewLocaticValuesValid(name: String?, radius: Float) -> Bool {
        do {
            try validateLocaticName(name)
            try validateLocaticRadius(radius)

            return true
        } catch (let error as AddLocaticEntryValidation) {
            // Communicate with parent view model delegate and pass this error to show alert
        } catch {
            fatalError("Unknown error occurred")
        }

        return false
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
