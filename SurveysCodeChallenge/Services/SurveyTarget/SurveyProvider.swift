//
//  SurveyProvider.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation
import Moya

typealias SurveyCompletion = ((Result<[Survey], Error>) -> Void)

protocol AnySurveyProvider {
    func get(page: Int, perPage: Int, completion: @escaping SurveyCompletion)
}

final class SurveyProvider: AnySurveyProvider {
    private let provider: MoyaProvider<SurveyApi>

    init(provider: MoyaProvider<SurveyApi> = MoyaProvider<SurveyApi>()) {
        self.provider = provider
        self.provider.manager.retrier = RetrierHandler()
    }

    func get(page: Int, perPage: Int, completion: @escaping SurveyCompletion) {
        provider.request(.surveys(page: page, perPage: perPage), completion: { result in
            switch result {
            case .success(let value):
                guard let surveys: [Survey] = try? JSONDecoder().decode([Survey].self, from: value.data) else {
                    completion(.failure(Define.Error.Service.mapping))
                    return
                }
                completion(.success(surveys))
            case .failure(let error):
                completion(.failure(error))
            }
        })
    }
}
