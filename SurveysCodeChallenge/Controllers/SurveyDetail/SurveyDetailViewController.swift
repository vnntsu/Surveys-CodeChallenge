//
//  SurveyDetailViewController.swift
//  Surveys-CodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit

final class SurveyDetailViewController: UIViewController {
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var descriptionLabel: UILabel!
    @IBOutlet private weak var imageView: UIImageView!

    var viewModel: SurveyDetailViewModel?

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
    }

    private func configUI() {
        guard let viewModel = viewModel else { return }
        navigationItem.title = viewModel.title
        titleLabel.text = viewModel.title
        descriptionLabel.text = viewModel.description
        imageView.setImage(with: viewModel.imagePath)
    }
}

final class SurveyDetailViewModel: SurveyItem { }
