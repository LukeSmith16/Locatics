//
//  AddLocaticCardView.swift
//  Locatics
//
//  Created by Luke Smith on 14/09/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class AddLocaticCardView: UIView {
    @IBOutlet var contentView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var locaticNameTextField: UITextField!
    @IBOutlet weak var radiusLabel: UILabel!

    @IBOutlet var radiusSlider: SliderControl!
    @IBOutlet var addNewLocaticButton: ActionButton!

    @IBOutlet weak var locaticIconButton: UIButton!
    @IBOutlet weak var homeIconButton: UIButton!
    @IBOutlet weak var activityIconButton: UIButton!
    @IBOutlet weak var businessIconButton: UIButton!

    @IBOutlet var locaticIconButtons: [UIButton]!

    var addLocaticViewModel: AddLocaticViewModelInterface? {
        didSet {
            addLocaticViewModel?.viewDelegate = self
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupButtons()

        setupRadiusSlider()
        setupAddNewLocaticButton()

        setupShadow()
        setupCorners()
    }

    @IBAction func radiusSliderChanged(_ sender: Any) {
        addLocaticViewModel?.radiusDidChange(radiusSlider.value)
    }

    @IBAction func locaticIconButtonTapped(_ sender: UIButton) {
        addLocaticViewModel?.locaticIconDidChange(sender.tag)
        setSelected(sender)
    }

    @IBAction func addLocaticTapped(_ sender: Any) {
        addLocaticViewModel?.addLocaticWasTapped(locaticName: locaticNameTextField.text,
                                                 radius: radiusSlider.value)
    }

    func clearValues() {
        self.locaticNameTextField.text = nil
        self.radiusLabel.text = "Radius"
        self.radiusSlider.value = 0.0

        locaticIconButtonTapped(locaticIconButton)
    }
}

private extension AddLocaticCardView {
    func setupButtons() {
        locaticIconButton.setImage(UIImage(named: "locaticSelectedIcon")!, for: .selected)
        homeIconButton.setImage(UIImage(named: "homeLocaticSelectedIcon")!, for: .selected)
        activityIconButton.setImage(UIImage(named: "activitySelectedIcon")!, for: .selected)
        businessIconButton.setImage(UIImage(named: "workLocaticSelectedIcon")!, for: .selected)

        locaticIconButtonTapped(locaticIconButton)
    }

    func setupRadiusSlider() {
        radiusSlider.setup(sliderStyle: .distance, minValue: 0, maxValue: 100)
    }

    func setupAddNewLocaticButton() {
        addNewLocaticButton.setup(actionStyle: .save, actionTitle: "ADD NEW LOCATIC")
    }

    func setupShadow() {
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.09
    }

    func setupCorners() {
        self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.contentView.layer.cornerRadius = 25.0
    }

    func setSelected(_ button: UIButton) {
        for locaticIconButton in locaticIconButtons {
            locaticIconButton.isSelected = false
        }

        button.isSelected = true
    }
}

extension AddLocaticCardView: AddLocaticViewModelViewDelegate {
    func changeRadiusText(_ newRadiusText: String) {
        self.radiusLabel.text = newRadiusText
    }
}

extension AddLocaticCardView {
    func commonInit() {
        Bundle.main.loadNibNamed("AddLocaticCardView", owner: self, options: nil)

        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        addSubview(contentView)
    }
}
