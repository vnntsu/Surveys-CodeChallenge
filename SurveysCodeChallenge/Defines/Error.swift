//
//  Error.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

extension Define {
    struct Error { }
}

// MARK: - Define error
extension Define.Error {
    enum Data: Swift.Error {
        case indexOutOfRange
        case notFound
    }

    enum Service: Swift.Error {
        case mapping
        case createURL
    }
}
