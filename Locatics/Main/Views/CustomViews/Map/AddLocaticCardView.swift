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
    }

    @IBAction func addLocaticTapped(_ sender: Any) {
        addLocaticViewModel?.addLocaticWasTapped(locaticName: locaticNameTextField.text,
                                                 radius: radiusSlider.value)
    }

    func clearValues() {
        self.locaticNameTextField.text = nil
        self.radiusLabel.text = "Radius"
        self.radiusSlider.value = 0.0
    }
}

private extension AddLocaticCardView {
    func setupRadiusSlider() {
        radiusSlider.setup(sliderStyle: .distance, minValue: 0, maxValue: 100)
    }

    func setupAddNewLocaticButton() {
        addNewLocaticButton.setup(actionStyle: .save, actionTitle: "Add new Locatic")
    }

    func setupShadow() {
        self.contentView.layer.shadowColor = UIColor.black.cgColor
        self.contentView.layer.shadowOpacity = 0.09
    }

    func setupCorners() {
        self.contentView.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        self.contentView.layer.cornerRadius = 25.0
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
