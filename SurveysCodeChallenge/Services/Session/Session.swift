//
//  Session.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

struct Session {
    static var current: Session? {
        set {
            let encoder = JSONEncoder()
            guard let value = newValue, let encoded = try? encoder.encode(value) else { return }
            Keychain.shared.set(encoded, forKey: DefaultsKeys.token.rawValue)
        }
        get {
            let decoder = JSONDecoder()
            guard let data = Keychain.shared.getData(forKey: DefaultsKeys.token.rawValue),
                let current = try? decoder.decode(Session.self, from: data) else { return nil }
            return current
        }
    }

    var token: String = ""
    var type: String = ""
    var expires: Int = 0
    var createdAt: Int = 0

    var bearerToken: String {
        return "Bearer \(token)"
    }
}

// MARK: - Codable
extension Session: Codable {
    private enum CodingKeys: String, CodingKey {
        case token = "access_token"
        case type = "token_type"
        case expires = "expires_in"
        case createdAt = "created_at"
    }
}

// MARK: - Define
extension Session {
    private enum DefaultsKeys: String {
        case token = "current_token"
    }
}
