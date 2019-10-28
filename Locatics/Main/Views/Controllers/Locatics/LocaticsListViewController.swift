//
//  LocaticsViewController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import MapKit

class LocaticsListViewController: UIViewController {

    @IBOutlet weak var locaticsListCollectionView: LocaticsListCollectionView!
    @IBOutlet weak var mapView: MKMapView!
    @IBOutlet weak var visualEffectView: UIVisualEffectView!

    var navigationTitleView: NavigationTitleViewInterface?

    var locaticsViewModel: LocaticsViewModelInterface? {
        didSet {
            locaticsViewModel?.viewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabItemImage()
        setupNavigationTitleView()
        setupMapView()
        setupLocaticsListCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        animateVisualEffectView()
        prepareLocaticsListCollectionViewAnimation()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        animateLocaticsListCollectionView()
    }
}

private extension LocaticsListViewController {
    func setupTabItemImage() {
        self.navigationController?.tabItem.setTabItemImage(UIImage(named: "locaticsTabBarIconNormal")!,
                                                           for: .normal)
        self.navigationController?.tabItem.setTabItemImage(UIImage(named: "locaticsTabBarIconSelected")!,
                                                           for: .selected)
    }

    func setupNavigationTitleView() {
        self.navigationTitleView = navigationItem.setupTitleView(title: "My Locatics",
                                                                 subtitle: nil)
    }

    func setupMapView() {
        let userRegion = mapView.userLocation.coordinate
        self.mapView.setRegion(MKCoordinateRegion(center: userRegion,
                                                  latitudinalMeters: 500,
                                                  longitudinalMeters: 500),
                               animated: true)
    }

    func animateVisualEffectView() {
        self.visualEffectView.alpha = 0.0

        UIView.animate(withDuration: 0.7) {
            self.visualEffectView.alpha = 1.0
        }
    }

    func setupLocaticsListCollectionView() {
        self.locaticsListCollectionView.locaticsCollectionViewModel = locaticsViewModel?.locaticsCollectionViewModel
    }

    func prepareLocaticsListCollectionViewAnimation() {
        self.locaticsListCollectionView.alpha = 0.0
    }

    func animateLocaticsListCollectionView() {
        locaticsListCollectionView.animate()
    }
}

extension LocaticsListViewController: LocaticsViewModelViewDelegate {

}
