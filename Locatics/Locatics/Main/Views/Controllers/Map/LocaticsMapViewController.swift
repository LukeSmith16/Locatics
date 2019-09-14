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
}

private extension LocaticsMapViewController {
    func setupNavigationTitleView() {
        let mainTitle = locaticsMapViewModel?.getMainTitle()
        let subtitle = locaticsMapViewModel?.getSubtitle()
        self.navigationTitleView = navigationItem.setupTitleView(title: mainTitle, subtitle: subtitle)
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
        navigationTitleView?.setNewTitle(title)
        navigationTitleView?.setNewSubtitle(subtitle)
    }

    func showAlert(title: String, message: String) {

    }
}
