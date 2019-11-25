//
//  ProgressView.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit

final class ProgressView: UIView {
    @IBOutlet var contentView: UIView!

    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }

    private func commonInit() {
        Bundle.main.loadNibNamed("ProgressView", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = bounds
        contentView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
    }
}

// MARK: - Public Actions
extension ProgressView {
    private static var current: ProgressView?

    static func show(on target: UIViewController) {
        if ProgressView.current != nil { return }
        ProgressView.current = ProgressView(frame: target.view.bounds)
        guard let progressView = ProgressView.current else { return }
        target.view.addSubview(progressView)
    }

    static func hide() {
        guard let progressView = ProgressView.current else { return }
        progressView.removeFromSuperview()
        ProgressView.current = nil
    }
}
