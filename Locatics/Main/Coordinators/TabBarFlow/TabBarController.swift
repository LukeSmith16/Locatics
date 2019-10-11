//
//  TabBarController.swift
//  Locatics
//
//  Created by Luke Smith on 06/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit
import Material

protocol TabBarControllerInterface: class {
    var onMapFlowSelect: ((UINavigationController) -> Void)? { get set }
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)? { get set }
}

enum TabIndex: Int {
    case map, locatics
}

final class TabBarController: TabsController, TabBarControllerInterface {
    var onMapFlowSelect: ((UINavigationController) -> Void)?
    var onLocaticsFlowSelect: ((UINavigationController) -> Void)?

    override func prepare() {
        super.prepare()
        setupDelegate()
        setupTabBar()
        setupInitialTabSelected()
    }
}

private extension TabBarController {
    func setupDelegate() {
        self.delegate = self
    }

    func setupTabBar() {
        tabBar.lineAlignment = .top
        tabBar.setLineColor(UIColor(colorTheme: .Interactable_Main), for: .selected)

        tabBar.setTabItemsColor(UIColor(colorTheme: .Interactable_Main), for: .selected)
        tabBar.setTabItemsColor(UIColor(colorTheme: .Interactable_Unselected), for: .normal)
    }

    func setupInitialTabSelected() {
        guard let initialNavController = viewControllers.first as? UINavigationController else {
            fatalError("Could not get initial NavController")
        }

        onMapFlowSelect?(initialNavController)
    }
}

extension TabBarController: TabsControllerDelegate {}

//func tabsController(tabsController: TabsController, didSelect viewController: UIViewController) {
//    guard let navigationVC = viewController as? NavigationViewController,
//        navigationVC.viewControllers.isEmpty else {
//        return
//    }
//
//    if selectedIndex == TabIndex.map.rawValue {
//        onMapFlowSelect?(navigationVC)
//    } else if selectedIndex == TabIndex.locatics.rawValue {
//        onLocaticsFlowSelect?(navigationVC)
//    }
//}
