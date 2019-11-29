//
//  SurveyApi.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation
import Moya

enum SurveyApi {

    case surveys(page: Int, perPage: Int)
    case auth
}

// MARK: - Adopt Moya
extension SurveyApi: TargetType {

    var baseURL: URL {
        guard let url = URL(string: "https://nimble-survey-api.herokuapp.com") else {
            fatalError("Cannot initialize with your URL string. Please check again!")
        }
        return url
    }

    var path: String {
        switch self {
        case .surveys:
            return "/surveys.json"
        case .auth:
            return "/oauth/token"
        }
    }

    var method: Moya.Method {
        switch self {
        case .surveys:
            return .get
        case .auth:
            return .post
        }
    }

    var task: Task {
        switch self {
        case .surveys(let page, let perPage):
            return .requestParameters(parameters: [Key.page.rawValue: page,
                                                   Key.perPage.rawValue: perPage],
                                      encoding: URLEncoding.queryString)
        case .auth:
            return .requestParameters(parameters: Define.data,
                                      encoding: URLEncoding.queryString)
        }
    }

    var headers: [String: String]? {
        return [
            "Content-Type": "application/json"
        ]
    }

    var sampleData: Data {
        return Data()
    }

    var validationType: ValidationType {
        return .successAndRedirectCodes
    }
}

// MARK: - Define default Data
extension SurveyApi {
    struct Define {
        static let data: [String: String] = [Key.grantType.rawValue: "password",
                                             Key.username.rawValue: "carlos@nimbl3.com",
                                             Key.password.rawValue: "antikera"]
    }

    private enum Key: String {
        case grantType = "grant_type"
        case username
        case password
        case page
        case perPage = "per_page"
    }
}
