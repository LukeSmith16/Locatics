//
//  TabBarController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

protocol TabBarControllerInterface: class {
    var onMapFlowSelect: ((UINavigationController) -> Void)? { get set }
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)? { get set }
}

enum TabIndex: Int {
    case map, locatics
}

final class TabBarController: UITabBarController, TabBarControllerInterface {
    var onMapFlowSelect: ((UINavigationController) -> Void)?
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupDelegate()
        setupInitialTabSelected()
    }
}

private extension TabBarController {
    func setupDelegate() {
        self.delegate = self
    }

    func setupInitialTabSelected() {
        guard let initialNavController = viewControllers?.first as? UINavigationController else {
            fatalError("Could not get initial NavController from main.storyboard")
        }

        onMapFlowSelect?(initialNavController)
    }
}

extension TabBarController: UITabBarControllerDelegate {
    func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
        guard let navigationVC = viewController as? UINavigationController, navigationVC.viewControllers.isEmpty else {
            return
        }

        if selectedIndex == TabIndex.map.rawValue {
            onMapFlowSelect?(navigationVC)
        } else if selectedIndex == TabIndex.locatics.rawValue {
            onLocaticsFlowSelect?(navigationVC)
        }
    }
}
