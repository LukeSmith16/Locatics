//
//  LocaticsViewController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import ViewAnimator

class LocaticsListViewController: UIViewController {

    @IBOutlet weak var locaticsListCollectionView: LocaticsListCollectionView!

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
        setupLocaticsListCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        locaticsListCollectionView.performBatchUpdates({
            locaticsListCollectionView.animate
        }, completion: nil)
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

    func setupLocaticsListCollectionView() {
        self.locaticsListCollectionView.locaticsCollectionViewModel = locaticsViewModel?.locaticsCollectionViewModel
    }
}

extension LocaticsListViewController: LocaticsViewModelViewDelegate {

}
