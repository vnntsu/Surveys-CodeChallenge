//
//  AuthProvider.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Moya

typealias AuthCompletion = ((Result<Bool, Error>) -> Void)

final class AuthProvider {
    private let provider: MoyaProvider<SurveyApi>

    init(provider: MoyaProvider<SurveyApi> = MoyaProvider<SurveyApi>()) {
        self.provider = provider
    }

    func auth(completion: @escaping AuthCompletion) {
        provider.request(.auth) { result in
            switch result {
            case .success(let value):
                guard let session: Session = try? JSONDecoder().decode(Session.self, from: value.data) else {
                    completion(.failure(MoyaError.encodableMapping(Define.Error.Service.mapping)))
                    return
                }
                Session.current = session
                completion(.success(true))
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}
