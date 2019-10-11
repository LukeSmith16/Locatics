//
//  LocaticsMapViewController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class LocaticsMapViewController: UIViewController {
    @IBOutlet weak var mapView: LocaticsMapView!
    @IBOutlet weak var addLocaticButton: UIButton!
    @IBOutlet weak var closeLocaticCardViewButton: UIButton!
    @IBOutlet weak var addLocaticCardView: AddLocaticCardView!
    @IBOutlet weak var locationMarkerPin: UIImageView!

    var navigationTitleView: NavigationTitleViewInterface?

    var locaticsMainViewModel: LocaticsMainViewModelInterface? {
        didSet {
            locaticsMainViewModel?.viewDelegate = self
            locaticsMainViewModel?.addLocaticViewDelegate = self
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabItemImage()
        setupNavigationTitleView()
        setupAddLocaticCardView()
        setupMapView()
        setupAddLocaticButton()
    }

    @IBAction func addLocaticTapped(_ sender: Any) {
        locaticsMainViewModel?.addLocaticWasTapped()
        addLocaticCardView.clearValues()
    }

    @IBAction func closeLocaticCardViewTapped(_ sender: Any) {
        locaticsMainViewModel?.closeLocaticCardViewWasTapped()
        addLocaticCardView.clearValues()
    }
}

private extension LocaticsMapViewController {
    func setupTabItemImage() {
        self.navigationController?.tabItem.setTabItemImage(UIImage(named: "mapTabBarIconNormal")!,
                                                           for: .normal)
        self.navigationController?.tabItem.setTabItemImage(UIImage(named: "mapTabBarIconSelected")!,
                                                           for: .selected)
    }

    func setupNavigationTitleView() {
        let mainTitle = locaticsMainViewModel?.getMainTitle()
        let subtitle = locaticsMainViewModel?.getSubtitle()
        self.navigationTitleView = navigationItem.setupTitleView(title: mainTitle, subtitle: subtitle)
    }

    func setupAddLocaticCardView() {
        self.addLocaticCardView.addLocaticViewModel = locaticsMainViewModel?.addLocaticViewModel
    }

    func setupMapView() {
        self.mapView.locaticsMapViewModel = locaticsMainViewModel?.locaticsMapViewModel
    }

    func setupAddLocaticButton() {
        self.addLocaticButton.layer.shadowColor = UIColor.black.cgColor
        self.addLocaticButton.layer.shadowOpacity = 0.20
        self.addLocaticButton.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}

extension LocaticsMapViewController: LocaticsMainViewModelViewDelegate {
    func setNavigationTitle(_ title: String) {
        let subtitle = locaticsMainViewModel?.getSubtitle()
        navigationTitleView?.setNewTitle(title)
        navigationTitleView?.setNewSubtitle(subtitle)
    }

    func showAlert(title: String, message: String) {
        let alertController = AlertController.create(title: title, message: message)
        self.present(alertController, animated: true, completion: nil)
    }

    func hideTabBar(_ shouldHide: Bool) {
        self.setTabBarHidden(shouldHide)
    }
}

extension LocaticsMapViewController: LocaticsMainAddLocaticViewModelViewDelegate {
    func shouldHideAddLocaticViews(_ shouldHide: Bool) {
        self.locationMarkerPin.isHidden = shouldHide
        self.addLocaticCardView.isHidden = shouldHide
        self.closeLocaticCardViewButton.isHidden = shouldHide
        mapView.removeAddLocaticRadiusAnnotation()
    }

    func getPinCurrentLocationCoordinate() -> Coordinate {
        let pinLocation = mapView.convert(locationMarkerPin.center,
                                          toCoordinateFrom: mapView)
        return pinLocation
    }
}
