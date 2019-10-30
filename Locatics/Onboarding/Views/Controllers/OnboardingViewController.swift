//
//  OnboardingViewController.swift
//  Locatics
//
//  Created by Luke Smith on 01/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

// swiftlint:disable line_length

class OnboardingViewController: UIPageViewController {
    var onboardingViewModel: OnboardingViewModelInterface? {
        didSet {
            onboardingViewModel?.viewDelegate = self
        }
    }

    let skipButton = UIButton()
    let nextButton = UIButton()

    let pageControl = UIPageControl()

    private var currentIndex: Int = 0 {
        didSet {
            updateSkipButton()
            updateNextButton()

            self.pageControl.currentPage = currentIndex
        }
    }

    private var pendingIndex: Int?

    override func viewDidLoad() {
        super.viewDidLoad()
        setupViews()
    }

    @objc func nextTapped(_ sender: UIButton) {
        onboardingViewModel?.nextWasTapped(for: currentIndex)
    }

    @objc func skipTapped(_ sender: UIButton) {
        onboardingViewModel?.skipWasTapped()
    }

    @IBAction func doneTapped(_ sender: Any) {
        onboardingViewModel?.handleFinishOnboarding()
    }

    @IBAction func permissionsTapped(_ sender: Any) {
        onboardingViewModel?.handlePermissionsTapped()
    }
}

private extension OnboardingViewController {
    func setupViews() {
        setupBackground()
        setupDSAndDelegate()
        setupPageViewControllers()
        setupBackgroundOnboardingTextView()
        setupSkipButton()
        setupPageControl()
        setupNextButton()
        setupNavigationStackView()
    }

    func setupBackground() {
        self.view.backgroundColor = UIColor(colorTheme: .Background)
    }

    func setupDSAndDelegate() {
        self.dataSource = self
        self.delegate = self
    }

    func setupPageViewControllers() {
        let initialPageViewController = onboardingViewModel!.getInitialPageViewController()
        self.setViewControllers([initialPageViewController], direction: .forward, animated: true, completion: nil)
    }

    func setupBackgroundOnboardingTextView() {
        let onboardingTextBackground = UIImageView(frame: CGRect(x: 0,
                                                                 y: 0,
                                                                 width: view.bounds.width,
                                                                 height: ScreenDesignable.onboardingBackgroundTextViewHeight))
        onboardingTextBackground.image = UIImage(named: "onboardingTextBackground")!
        onboardingTextBackground.translatesAutoresizingMaskIntoConstraints = false

        view.addSubview(onboardingTextBackground)
        view.sendSubviewToBack(onboardingTextBackground)

        NSLayoutConstraint(item: onboardingTextBackground,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1.76,
                           constant: 0).isActive = true
        onboardingTextBackground.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true
    }

    func setupSkipButton() {
        skipButton.setTitle("Skip", for: .normal)
        skipButton.titleLabel?.font = Font.init(.installed(.HelveticaBold), size: .custom(16.0)).instance
        skipButton.setTitleColor(UIColor(colorTheme: .Title_Action),
                                 for: .normal)
        skipButton.addTarget(self, action: #selector(skipTapped(_:)), for: .touchUpInside)
    }

    func setupPageControl() {
        pageControl.numberOfPages = 4
        pageControl.currentPage = 0
    }

    func setupNextButton() {
        nextButton.setTitle("Next", for: .normal)
        nextButton.titleLabel?.font = Font.init(.installed(.HelveticaRegular), size: .custom(16.0)).instance
        nextButton.setTitleColor(UIColor(colorTheme: .Title_Action),
                                 for: .normal)
        nextButton.addTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
    }

    func setupNavigationStackView() {
        let stackView = UIStackView(arrangedSubviews: [skipButton, pageControl, nextButton])
        stackView.center = self.view.center
        stackView.distribution = .equalCentering
        stackView.alignment = .center
        stackView.axis = .horizontal
        stackView.translatesAutoresizingMaskIntoConstraints = false

        self.view.addSubview(stackView)
        setupConstraintsForNavigationStackView(stackView)
    }

    func setupConstraintsForNavigationStackView(_ stackView: UIStackView) {
        stackView.centerXAnchor.constraint(equalTo: self.view.centerXAnchor).isActive = true

        NSLayoutConstraint(item: stackView,
                           attribute: .centerY,
                           relatedBy: .equal,
                           toItem: self.view,
                           attribute: .centerY,
                           multiplier: 1.876,
                           constant: 0).isActive = true

        stackView.leadingAnchor.constraint(equalTo: self.view.leadingAnchor, constant: 35).isActive = true
        stackView.trailingAnchor.constraint(equalTo: self.view.trailingAnchor, constant: -35).isActive = true
    }
}

extension OnboardingViewController: UIPageViewControllerDataSource {
    func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return onboardingViewModel!.pageViewControllerCount()
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerBefore viewController: UIViewController) -> UIViewController? {
        return onboardingViewModel?.getPageViewController(before: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            viewControllerAfter viewController: UIViewController) -> UIViewController? {
        return onboardingViewModel?.getPageViewController(after: viewController)
    }

    func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        self.pendingIndex = onboardingViewModel?.indexOf(viewController: pendingViewControllers.first!)
    }

    func pageViewController(_ pageViewController: UIPageViewController,
                            didFinishAnimating finished: Bool,
                            previousViewControllers: [UIViewController],
                            transitionCompleted completed: Bool) {
        guard completed, let pendingIndex = pendingIndex else { return }
        self.currentIndex = pendingIndex
    }
}

extension OnboardingViewController: UIPageViewControllerDelegate {}

extension OnboardingViewController: OnboardingViewModelViewDelegate {
    func locationPermissionsWereDenied() {
        let alertController = AlertController.create(title: "Location Permissions",
                                                     message: "You must allow Locatics to use your location before proceeding",
                                                     actionTitle: "App Settings") { [unowned self] in
                                                        self.onboardingViewModel?.handleGoToAppSettings()
        }

        self.present(alertController, animated: true, completion: nil)
    }

    func goToNextPage(nextVC: UIViewController) {
        self.currentIndex += 1
        self.setViewControllers([nextVC], direction: .forward, animated: true, completion: nil)
    }

    func goToLastPage(lastVC: UIViewController) {
        self.currentIndex = 3
        self.setViewControllers([lastVC], direction: .forward, animated: true, completion: nil)
    }
}

private extension OnboardingViewController {
    func updateSkipButton() {
        if currentIndex == 3 {
            self.skipButton.alpha = 0.0
        } else {
            self.skipButton.alpha = 1.0
        }
    }

    func updateNextButton() {
        if currentIndex == 3 {
            nextButton.setTitle("Done", for: .normal)
            nextButton.titleLabel?.font = Font.init(.installed(.HelveticaBold), size: .custom(16.0)).instance

            nextButton.removeTarget(self, action: #selector(nextTapped(_:)), for: .touchUpInside)
            nextButton.addTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
        } else {
            nextButton.removeTarget(self, action: #selector(doneTapped(_:)), for: .touchUpInside)
            setupNextButton()
        }
    }
}
