//
//  LocaticsViewController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class LocaticsListViewController: UIViewController {

    var navigationTitleView: NavigationTitleViewInterface?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupTabItemImage()
    }
}

private extension LocaticsListViewController {
    func setupTabItemImage() {
        self.navigationController?.tabItem.setTabItemImage(UIImage(named: "locaticsTabBarIconNormal")!,
                                                           for: .normal)
        self.navigationController?.tabItem.setTabItemImage(UIImage(named: "locaticsTabBarIconSelected")!,
                                                           for: .selected)
    }
}
