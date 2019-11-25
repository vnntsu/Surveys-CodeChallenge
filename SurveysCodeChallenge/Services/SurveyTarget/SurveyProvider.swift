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

final class SurveyProvider {
    static var shared: SurveyProvider {
        return SurveyProvider(provider: MoyaProvider<SurveyApi>())
    }

    private let provider: MoyaProvider<SurveyApi>

    init(provider: MoyaProvider<SurveyApi>) {
        self.provider = provider
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
