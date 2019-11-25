//
//  SurveyCell.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit

final class SurveyCell: UICollectionViewCell {

    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    private var didAwake: Bool = false

    override func awakeFromNib() {
        super.awakeFromNib()
        didAwake = true
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        guard didAwake else { return }
        imageView.cancelDownload()
        imageView.image = nil
    }

    func configure(with viewModel: SurveyItem) {
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.setImage(with: viewModel.imagePath)
    }
}
