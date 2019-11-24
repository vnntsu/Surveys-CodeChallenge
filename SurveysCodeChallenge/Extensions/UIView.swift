//
//  UIView.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit

extension UIView {
    var size: CGSize {
        return bounds.size
    }

    var height: CGFloat {
        return size.height
    }

    var width: CGFloat {
        return size.width
    }

    var origin: CGPoint {
        return frame.origin
    }

    var originX: CGFloat {
        return origin.x
    }

    var originY: CGFloat {
        return origin.y
    }
}
