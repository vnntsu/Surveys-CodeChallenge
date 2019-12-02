//
//  Keychain.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/28/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

final class Keychain {
    var keyPrefix: String

    var synchronizable: Bool = false

    var status: OSStatus = errSecSuccess

    static let shared: Keychain = {
        let instance = Keychain(keyPrefix: kKeychainPrefix)
        return instance
    }()

    init(keyPrefix: String = "") {
        self.keyPrefix = keyPrefix
    }
}

// MARK: - api
extension Keychain {

    @discardableResult
    func set(_ value: String, forKey key: String) -> Bool {
        if let value = value.data(using: String.Encoding.utf8) {
            return set(value, forKey: key)
        }

        return false
    }

    @discardableResult
    func set(_ value: Data, forKey key: String) -> Bool {
        delete(key)

        let prefixedKey = keyWithPrefix(key)

        var query: [String: Any] = [
            KeychainConstants.kClass: kSecClassGenericPassword,
            KeychainConstants.attrAccount: prefixedKey,
            KeychainConstants.valueData: value
        ]

        query = addSynchronizableIfRequired(query, addingItems: true)

        status = SecItemAdd(query as CFDictionary, nil)

        return status == errSecSuccess
    }

    func get(forKey key: String) -> String? {
        if let data = getData(forKey: key) {
            if let currentString = String(data: data, encoding: .utf8) {
                return currentString
            }

            status = errSecDecode
        }

        return nil
    }

    func getData(forKey key: String, asReference: Bool = false) -> Data? {
        let prefixedKey = keyWithPrefix(key)

        var query: [String: Any] = [
            KeychainConstants.kClass: kSecClassGenericPassword,
            KeychainConstants.attrAccount: prefixedKey,
            KeychainConstants.returnData: true
        ]

        query = addSynchronizableIfRequired(query, addingItems: false)

        var result: AnyObject?

        status = withUnsafeMutablePointer(to: &result) {
            SecItemCopyMatching(query as CFDictionary, UnsafeMutablePointer($0))
        }

        if status == errSecSuccess {
            return result as? Data
        }

        return nil
    }

    @discardableResult
    func delete(_ key: String) -> Bool {
        let prefixedKey = keyWithPrefix(key)

        var query: [String: Any] = [
            KeychainConstants.kClass: kSecClassGenericPassword,
            KeychainConstants.attrAccount: prefixedKey
        ]

        query = addSynchronizableIfRequired(query, addingItems: false)

        status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }

    @discardableResult
    func clear() -> Bool {
        var query: [String: Any] = [ KeychainConstants.kClass: kSecClassGenericPassword ]
        query = addSynchronizableIfRequired(query, addingItems: false)

        status = SecItemDelete(query as CFDictionary)

        return status == errSecSuccess
    }
}

struct KeychainConstants {
    static var attrAccount: String { return toString(kSecAttrAccount) }
    static var valueData: String { return toString(kSecValueData) }
    static var attrSynchronizable: String { return toString(kSecAttrSynchronizable) }
    static var kClass: String { return toString(kSecClass) }
    static var returnData: String { return toString(kSecReturnData) }

    static func toString(_ value: CFString) -> String {
        return value as String
    }
}

// MARK: - Define
private extension Keychain {
    static let kKeychainPrefix: String = "surveys_code_challenge"

    private func keyWithPrefix(_ key: String) -> String {
        return "\(keyPrefix)_\(key)"
    }

    private func addSynchronizableIfRequired(_ items: [String: Any], addingItems: Bool) -> [String: Any] {
        if !synchronizable { return items }
        var result: [String: Any] = items
        result[KeychainConstants.attrSynchronizable] = addingItems ? true : kSecAttrSynchronizableAny
        return result
    }
}
