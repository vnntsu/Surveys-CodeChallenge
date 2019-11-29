//
//  URLRequest.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

extension URLRequest {
    mutating func update(session: Session?) {
        if let session = session {
            setValue(session.bearerToken, forHTTPHeaderField: "Authorization")
        }
    }
}
