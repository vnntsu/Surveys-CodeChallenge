//
//  UIViewController.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit

extension UIViewController {
    func showError(_ error: Error) {
        showAlert(title: Define.title, message: error.localizedDescription)
    }

    func showAlert(title: String?, message: String?) {
        let alertController = UIAlertController(title: title, message: message, preferredStyle: .alert)
        let action = UIAlertAction(title: Define.OK, style: .default)
        alertController.addAction(action)
        present(alertController, animated: true, completion: nil)
    }

    func showAuthor() {
        showAlert(title: Define.title, message: Define.authorName)
    }

    func indicator(shouldShow: Bool) {
        if shouldShow {
            ProgressView.show(on: self)
        } else {
            ProgressView.hide()
        }
    }
}

private extension Define {
    static let title = "Surveys"
    static let OK = "OK"
    static let author = "Author"
    static let authorName = "Su Nguyen T."
}
