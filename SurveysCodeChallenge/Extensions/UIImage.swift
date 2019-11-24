//
//  UIImage.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit
import Kingfisher

extension UIImageView {
    func cancelDownload() {
        kf.cancelDownloadTask()
    }

    func setImage(with path: String) {
        kf.setImage(with: URL(string: path))
    }
}
