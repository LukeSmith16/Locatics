//
//  OnboardingWelcomePageViewController.swift
//  Locatics
//
//  Created by Luke Smith on 03/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class OnboardingWelcomePageViewController: UIViewController, OnboardingViewControllerDesignable {
    @IBOutlet weak var onboardingImageView: UIImageView!

    @IBOutlet weak var onboardingTitleLabel: UILabel!
    @IBOutlet weak var onboardingDetailLabel: UILabel!

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }
}
