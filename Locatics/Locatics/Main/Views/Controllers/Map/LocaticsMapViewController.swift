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

    var locaticsMapViewModel: LocaticsMapViewModelInterface? {
        didSet {
            locaticsMapViewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupNavigationTitle()
        setupMapView()
    }
}

private extension LocaticsMapViewController {
    func setupNavigationTitle() {
        let mainTitle = locaticsMapViewModel?.getMainTitle()
        let subtitle = locaticsMapViewModel?.getSubtitle()
        self.navigationItem.setTitle(title: mainTitle, subtitle: subtitle)
    }

    func setupMapView() {
        self.mapView.delegate = self
    }
}

extension LocaticsMapViewController: MKMapViewDelegate {

}

extension LocaticsMapViewController: LocaticsMapViewModelViewDelegate {
    func setNavigationTitle(_ title: String) {
        let subtitle = locaticsMapViewModel?.getSubtitle()
        self.navigationItem.setTitle(title: title, subtitle: subtitle)
    }

    func showAlert(title: String, message: String) {
        
    }
}
