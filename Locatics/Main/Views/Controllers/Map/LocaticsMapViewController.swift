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

    @IBOutlet weak var locationMarkerPinYConstraint: NSLayoutConstraint!
    @IBOutlet weak var locationMarkerPin: UIImageView!

    @IBOutlet weak var addLocaticCardView: AddLocaticCardView!
    @IBOutlet weak var addLocaticCardViewBottomConstraint: NSLayoutConstraint!
    @IBOutlet weak var addLocaticCardViewHeightConstraint: NSLayoutConstraint!

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
        setupLocationMarkerPin()
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
        locaticsMainViewModel?.getRecentLocation()
        self.navigationTitleView = navigationItem.setupTitleView(title: "Fetching Location...", subtitle: nil)
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

    func setupLocationMarkerPin() {
        self.locationMarkerPin.clipsToBounds = false
        self.locationMarkerPin.layer.shadowColor = UIColor.black.cgColor
        self.locationMarkerPin.layer.shadowOpacity = 0.15
        self.locationMarkerPin.layer.shadowOffset = CGSize(width: 0, height: 5)
    }
}

extension LocaticsMapViewController: LocaticsMainViewModelViewDelegate {
    func setNavigationTitleView(title: String, subtitle: String) {
        navigationTitleView?.setNewTitle(title)
        navigationTitleView?.setNewSubtitle(subtitle)
    }

    func showAlert(title: String, message: String) {
        let alertController = AlertController.create(title: title, message: message)
        self.present(alertController, animated: true, completion: nil)
    }
}

extension LocaticsMapViewController: LocaticsMainAddLocaticViewModelViewDelegate {
    func shouldHideAddLocaticViews(_ shouldHide: Bool) {
        shouldHide ? animateAddLocaticCardViewHide() : animateAddLocaticCardViewShow()
        mapView.removeAddLocaticRadiusAnnotation()
    }

    func getPinCurrentLocationCoordinate() -> Coordinate {
        let pinLocation = mapView.convert(locationMarkerPin.center,
                                          toCoordinateFrom: mapView)
        return pinLocation
    }
}

private extension LocaticsMapViewController {
    func animateAddLocaticCardViewShow() {
        self.addLocaticButton.isUserInteractionEnabled = false
        self.locationMarkerPin.isHidden = false
        self.addLocaticCardView.isHidden = false
        self.closeLocaticCardViewButton.isHidden = false

        self.addLocaticCardViewHeightConstraint.constant = ScreenDesignable.alertHeight
        self.addLocaticCardViewBottomConstraint.constant = 0

        self.locationMarkerPinYConstraint.constant = 0

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 5,
                       initialSpringVelocity: 9,
                       options: [.curveEaseInOut], animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: nil)
    }

    func animateAddLocaticCardViewHide() {
        self.addLocaticCardViewHeightConstraint.constant = 0
        self.addLocaticCardViewBottomConstraint.constant = -50

        self.locationMarkerPinYConstraint.constant = -300

        UIView.animate(withDuration: 1,
                       delay: 0,
                       usingSpringWithDamping: 4,
                       initialSpringVelocity: 7,
                       options: [.curveEaseInOut], animations: { [weak self] in
            self?.view.layoutIfNeeded()
        }, completion: { [weak self] (_) in
            self?.addLocaticButton.isUserInteractionEnabled = true
            self?.locationMarkerPin.isHidden = true
            self?.addLocaticCardView.isHidden = true
            self?.closeLocaticCardViewButton.isHidden = true
        })
    }
}
