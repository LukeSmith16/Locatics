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

    var navigationTitleView: NavigationTitleViewInterface?

    var locaticsMapViewModel: LocaticsMapViewModelInterface? {
        didSet {
            locaticsMapViewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitleView()
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

    }

    func updateMapRegion(location: Coordinate, latMeters: Double, lonMeters: Double) {
        let coordinateRegion = MKCoordinateRegion(center: location,
                                                  latitudinalMeters: latMeters,
                                                  longitudinalMeters: lonMeters)
        mapView.setRegion(coordinateRegion, animated: true)
    }
}
