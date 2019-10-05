//
//  LocaticsMapViewController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import MapKit

class LocaticsMapViewController: UIViewController {
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var addLocaticButton: UIButton!
    @IBOutlet weak var addLocaticCardView: AddLocaticCardView!

    @IBOutlet weak var locationMarkerRadiusView: UIView!
    @IBOutlet weak var locationMarkerRadiusHeightConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationMarkerRadiusWidthConstraint: NSLayoutConstraint!

    @IBOutlet weak var locationMarkerPin: UIImageView!

    var navigationTitleView: NavigationTitleViewInterface?

    var locaticsMapViewModel: LocaticsMapViewModelInterface? {
        didSet {
            locaticsMapViewModel?.viewDelegate = self
            locaticsMapViewModel?.addLocaticViewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitleView()
        setupAddLocaticCardView()
        setupMapView()
    }

    @IBAction func addLocaticTapped(_ sender: Any) {
        locaticsMapViewModel?.addLocaticWasTapped()
    }
}

private extension LocaticsMapViewController {
    func setupNavigationTitleView() {
        let mainTitle = locaticsMapViewModel?.getMainTitle()
        let subtitle = locaticsMapViewModel?.getSubtitle()
        self.navigationTitleView = navigationItem.setupTitleView(title: mainTitle, subtitle: subtitle)
    }

    func setupAddLocaticCardView() {
        self.addLocaticCardView.addLocaticViewModel = locaticsMapViewModel?.addLocaticViewModel
    }

    func setupMapView() {
        self.mapView.delegate = self
        self.mapView.showsUserLocation = true
        self.mapView.tintColor = UIColor(colorTheme: .Interactable_Secondary)

        locaticsMapViewModel?.getUserRegion()
    }
}

extension LocaticsMapViewController: MKMapViewDelegate {}

extension LocaticsMapViewController: LocaticsMapViewModelViewDelegate {
    func setNavigationTitle(_ title: String) {
        let subtitle = locaticsMapViewModel?.getSubtitle()
        navigationTitleView?.setNewTitle(title)
        navigationTitleView?.setNewSubtitle(subtitle)
    }

    func showAlert(title: String, message: String) {
        let alertController = AlertController.create(title: "", message: "")
        self.present(alertController, animated: true, completion: nil)
    }

    func zoomToUserLocation(latMeters: Double, lonMeters: Double) {
        let userLocation = mapView.userLocation.coordinate
        updateMapRegion(location: userLocation, latMeters: latMeters, lonMeters: lonMeters)
    }

    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: latMeters,
                                                  longitudinalMeters: lonMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }

    func hideTabBar(_ shouldHide: Bool) {
        self.setTabBarHidden(shouldHide)
    }
}

extension LocaticsMapViewController: LocaticsMapAddLocaticViewModelViewDelegate {
    func showAddLocaticCardView() {
        self.addLocaticCardView.isHidden = false
    }

    func closeAddLocaticCardView() {
        self.addLocaticCardView.isHidden = true
    }

    func showLocationMarkerPin() {
        shouldHideLocationMarkerViews(false)
    }

    func getLocationPinCoordinate() -> Coordinate {
        let pinLocation = mapView.convert(locationMarkerPin.center,
                                          toCoordinateFrom: mapView)
        return pinLocation
    }

    func updateLocationMarkerRadiusConstraint(withNewConstant constant: CGFloat) {
        locationMarkerRadiusHeightConstraint.constant = constant
        locationMarkerRadiusWidthConstraint.constant = constant

        locationMarkerRadiusView.layoutIfNeeded()
    }
}

private extension LocaticsMapViewController {
    func shouldHideLocationMarkerViews(_ shouldHide: Bool) {
        self.locationMarkerPin.isHidden = shouldHide
        self.locationMarkerRadiusView.isHidden = shouldHide
    }
}
