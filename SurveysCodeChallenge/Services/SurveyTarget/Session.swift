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
            UserDefaults.standard.set(encoded, forKey: DefaultsKeys.current.rawValue)
        }
        get {
            let decoder = JSONDecoder()
            guard let data = UserDefaults.standard.object(forKey: DefaultsKeys.current.rawValue) as? Data,
                let current = try? decoder.decode(Session.self, from: data) else { return nil }
            return current
        }
    }

    var token: String = ""
    var type: String = ""
    var expires: Int = 0
    var createdAt: Int = 0

    var expired: Bool {
        let expiredDate: Date = Date(timeIntervalSince1970: TimeInterval(createdAt + expires))
        return expiredDate.isInPast
    }

    func isValid() -> Bool {
        return token.isNotEmpty && !expired
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
        case current
    }
}

private extension Date {
    var isInPast: Bool {
        return self < Date()
    }
}
