//
//  LocaticsMapNavigationViewController.swift
//  Locatics
//
//  Created by Luke Smith on 07/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class NavigationViewController: UINavigationController {
    override func viewDidLoad() {
        super.viewDidLoad()
        setupBackgroundView()
        navigationBar.setupDefaultNavigationBarAppearance()
    }
}

private extension NavigationViewController {
    func setupBackgroundView() {
        self.view.backgroundColor = .clear
    }
}
