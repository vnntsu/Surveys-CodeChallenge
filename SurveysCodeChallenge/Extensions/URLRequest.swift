//
//  URLRequest.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func update(session: Session) {
        let type = TokenType(value: session.type)
        switch type {
        case .bearer:
            let authValue = type.value + " " + session.token
            addValue(authValue, forHTTPHeaderField: "Authorization")
        }
    }
}
