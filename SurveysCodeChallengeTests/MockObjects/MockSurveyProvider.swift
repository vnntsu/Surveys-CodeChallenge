//
//  MockSurveyProvider.swift
//  SurveysCodeChallengeTests
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation
@testable import SurveysCodeChallenge

final class MockSurveyProvider {
    var shouldSuccess: Bool = true
    var isEmptyData: Bool = false
}

// MARK: - Adopt AnySurveyProvider
extension MockSurveyProvider: AnySurveyProvider {
    func get(page: Int, perPage: Int, completion: @escaping SurveyCompletion) {
        if shouldSuccess {
            if isEmptyData {
                completion(.success([]))
            } else {
                completion(.success(Survey.surveys))
            }
        } else {
            completion(.failure(Define.Error.Mock.fail))
        }
    }
}

// MARK: - Mock Error
private extension Define.Error {
    enum Mock: Swift.Error {
        case fail
    }
}

// MARK: - Mock model
extension Survey {
    static let survey: Survey = {
        return Survey(id: "surveyId", title: "survey title", description: "survey description", coverImageURL: "coverImageURL")
    }()

    static var surveys: [Survey] {
        return Array(repeating: survey, count: 10)
    }
}
