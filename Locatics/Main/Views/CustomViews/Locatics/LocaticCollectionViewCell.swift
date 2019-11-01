//
//  LocaticCollectionViewCell.swift
//  Locatics
//
//  Created by Luke Smith on 21/10/2019.
//  Copyright © 2019 Luke Smith. All rights reserved.
//

import UIKit

class LocaticCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var locaticNameLabel: UILabel!
    @IBOutlet weak var locaticTimeSpentLabel: UILabel!
    @IBOutlet weak var locaticChartView: LocaticChartView!
    @IBOutlet weak var locaticIconImageView: UIImageView!

    var locaticCellViewModel: LocaticCellViewModelInterface? {
        didSet {
            configureCellViews()
        }
    }

    private func configureCellViews() {
        guard let locaticCellViewModel = locaticCellViewModel else { return }
        self.locaticNameLabel.text = locaticCellViewModel.locatic.name
        self.locaticTimeSpentLabel.text = locaticCellViewModel.hoursSpentThisWeek
        self.locaticChartView.locaticChartViewModel = locaticCellViewModel.locaticChartViewModel
        self.locaticIconImageView.image = UIImage(named: locaticCellViewModel.locatic.iconPath)
    }

    override func awakeFromNib() {
        super.awakeFromNib()
        setupViews()
    }
}

private extension LocaticCollectionViewCell {
    func setupViews() {
        setupCellView()
        setupShadows()
        setupFonts()
        setupColors()
    }

    func setupCellView() {
        self.cellView.backgroundColor = UIColor(colorTheme: .Background)
        self.cellView.layer.cornerRadius = 8.0

        self.cellView.layer.shadowColor = UIColor.black.cgColor
        self.cellView.layer.shadowOpacity = 0.15
        self.cellView.layer.shadowOffset = CGSize(width: 0, height: 4)
    }

    func setupShadows() {
        self.locaticIconImageView.clipsToBounds = false
        self.locaticIconImageView.layer.shadowColor = UIColor.black.cgColor
        self.locaticIconImageView.layer.shadowOpacity = 0.15
        self.locaticIconImageView.layer.shadowOffset = CGSize(width: 0, height: 2)
    }

    func setupFonts() {
        self.locaticNameLabel.font = Font.init(.installed(.HelveticaRegular), size: .standard(.h1)).instance
        self.locaticTimeSpentLabel.font = Font.init(.installed(.HelveticaRegular), size: .standard(.h3)).instance
    }

    func setupColors() {
        self.locaticNameLabel.textColor = UIColor(colorTheme: .Title_Main)
        self.locaticTimeSpentLabel.textColor = UIColor(colorTheme: .Title_Secondary)
    }
}
