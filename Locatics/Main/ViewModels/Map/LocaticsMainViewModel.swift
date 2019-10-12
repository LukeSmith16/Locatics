//
//  LocaticsMainViewModel.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

// swiftlint:disable line_length

import Foundation
import CoreGraphics

protocol LocaticsMainViewModelInterface: class {
    var viewDelegate: LocaticsMainViewModelViewDelegate? {get set}
    var addLocaticViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate? {get set}

    var addLocaticViewModel: AddLocaticViewModelInterface? {get}
    var locaticsMapViewModel: LocaticsMapViewModelInterface? {get}

    func getMainTitle() -> String
    func getSubtitle() -> String

    func addLocaticWasTapped()
    func closeLocaticCardViewWasTapped()
}

protocol LocaticsMainLocationPinCoordinateDelegate: class {
    func getPinCurrentLocationCoordinate() -> Coordinate
}

protocol LocaticsMainAddLocaticViewModelViewDelegate: LocaticsMainLocationPinCoordinateDelegate {
    func shouldHideAddLocaticViews(_ shouldHide: Bool)
}

protocol LocaticsMainMapViewModelViewDelegate: class {
    func showAlert(title: String, message: String)
}

protocol LocaticsMainViewModelViewDelegate: LocaticsMainMapViewModelViewDelegate {
    func setNavigationTitle(_ title: String)
}

class LocaticsMainViewModel: LocaticsMainViewModelInterface {
    weak var viewDelegate: LocaticsMainViewModelViewDelegate?
    weak var addLocaticViewDelegate: LocaticsMainAddLocaticViewModelViewDelegate?

    var addLocaticViewModel: AddLocaticViewModelInterface?
    var locaticsMapViewModel: LocaticsMapViewModelInterface?

    var locationManager: LocationManagerInterface? {
        didSet {
            locationManager?.locationDelegate = self
        }
    }

    var locaticStorage: LocaticStorageInterface? {
        didSet {
            locaticStorage?.persistentStorageObserver.add(self)
        }
    }

    var locaticVisitStorage: LocaticVisitStorageInterface?

    func getMainTitle() -> String {
        guard let lastVisitedLocation = locationManager?.lastVisitedLocation else {
            setCurrentLocationName()
            return "Fetching location..."
        }

        return (lastVisitedLocation.description).capitalized
    }

    func getSubtitle() -> String {
        guard let lastVisitedLocation = locationManager?.lastVisitedLocation else {
            return "Just now"
        }

        let formattedArrivalDate = DateFormatterManager.hoursMinutes(from: lastVisitedLocation.date)
        return ("Since " + formattedArrivalDate).uppercased()
    }

    func addLocaticWasTapped() {
        locaticsMapViewModel?.goToUserRegion(force: true)
        addLocaticViewDelegate?.shouldHideAddLocaticViews(false)
    }

    func closeLocaticCardViewWasTapped() {
        closeAddLocaticCardView()
    }
}

private extension LocaticsMainViewModel {
    func setCurrentLocationName() {
        locationManager?.findCurrentLocation(completion: { [unowned self] (result) in
            switch result {
            case .success(let success):
                self.viewDelegate?.setNavigationTitle(success.description)
            case .failure(let failure):
                self.viewDelegate?.showAlert(title: "Error", message: failure.localizedDescription)
            }
        })
    }

    func fetchLocaticMatchingName(_ locaticName: String,
                                  completionHandler: @escaping (_ locatic: LocaticData?) -> Void) {
        let matchingNamePredicate = NSPredicate(format: "%K == %@", #keyPath(Locatic.name), locaticName)
        locaticStorage?.fetchLocatics(predicate: matchingNamePredicate,
                                      sortDescriptors: nil,
                                      completion: { [weak self] (completion) in
                                        switch completion {
                                        case .success(let success):
                                            completionHandler(success.first)
                                        case .failure(let failure):
                                            self?.showAlert(title: "Error fetching Locatic",
                                                            message: failure.localizedDescription)
                                            completionHandler(nil)
                                        }
        })
    }
}

extension LocaticsMainViewModel: LocationManagerDelegate {
    func locationPermissionsNotAuthorised() {
        viewDelegate?.showAlert(title: "Permissions Not Authorised",
                                message: "Please enable permissions by going to the apps settings")
    }

    func userDidEnterLocaticRegion(regionIdentifier: String) {
        fetchLocaticMatchingName(regionIdentifier) { [weak self] (locatic) in
            guard let locatic = locatic else { return }

            self?.locaticVisitStorage?.insertLocaticVisit(entryDate: Date(),
                                                          locatic: locatic,
                                                          completion: { (error) in
                                                            if error != nil {
                                                                self?.viewDelegate?.showAlert(title: "Error entering Locatic region",
                                                                                              message: error!.localizedDescription)
                                                            }
            })
        }
    }

    func userDidLeaveLocaticRegion(regionIdentifier: String) {
        fetchLocaticMatchingName(regionIdentifier) { [weak self] (locatic) in
            guard let locatic = locatic else { return }

            guard let locaticVisits = locatic.locaticVisits?.array as? [LocaticVisitData],
                  let recentLocaticVisit = locaticVisits.first(where: { $0.exitDate == nil }) else {
                return
            }

            self?.locaticVisitStorage?.updateLocaticVisit(locaticVisit: recentLocaticVisit,
                                                          exitDate: Date(),
                                                          completion: { (error) in
                                                            if error != nil {
                                                                self?.viewDelegate?.showAlert(title: "Error leaving Locatic region",
                                                                                              message: error!.localizedDescription)
                                                            }
            })
        }
    }
}

extension LocaticsMainViewModel: LocaticPersistentStorageDelegate {
    func locaticWasInserted(_ insertedLocatic: LocaticData) {
        locationManager?.startMonitoringRegion(for: insertedLocatic)
    }

    func locaticWasUpdated(_ updatedLocatic: LocaticData) {
        // Locatic name will suffice for now as that will be constant (You can't change the name of a Locatic)
        locationManager?.stopMonitoringRegion(for: updatedLocatic)
        locationManager?.startMonitoringRegion(for: updatedLocatic)
    }

    func locaticWasDeleted(_ deletedLocatic: LocaticData) {
        locationManager?.stopMonitoringRegion(for: deletedLocatic)
    }
}

extension LocaticsMainViewModel: LocaticPinLocationDelegate {
    func getPinCurrentLocationCoordinate() -> Coordinate {
        return addLocaticViewDelegate!.getPinCurrentLocationCoordinate()
    }

    func updatePinAnnotationRadius(toRadius radius: Double) {
        locaticsMapViewModel?.updatePinAnnotationRadius(toRadius: radius)
    }
}

extension LocaticsMainViewModel: LocaticEntryValidationDelegate {
    func validationErrorOccured(_ error: String) {
        viewDelegate?.showAlert(title: "Error adding Locatic", message: error)
    }

    func closeAddLocaticCardView() {
        addLocaticViewDelegate?.shouldHideAddLocaticViews(true)
    }
}

extension LocaticsMainViewModel: LocaticsMainMapViewModelViewDelegate {
    func showAlert(title: String, message: String) {
        viewDelegate?.showAlert(title: title, message: message)
    }
}
