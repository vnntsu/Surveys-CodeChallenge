//
//  TokenType.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

enum TokenType: String {
    case bearer

    var value: String {
        switch self {
        case .bearer: return "Bearer"
        }
    }
}

// MARK: - Initiual
extension TokenType {
    init(value: String) {
        guard let type = TokenType(rawValue: value) else {
            self = .bearer
            return
        }
        self = type
    }
}
