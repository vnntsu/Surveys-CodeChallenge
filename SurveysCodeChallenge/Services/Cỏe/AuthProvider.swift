//
//  AuthProvider.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Moya

final class AuthProvider {
    private let provider: MoyaProvider<SurveyApi>

    init(provider: MoyaProvider<SurveyApi> = MoyaProvider<SurveyApi>()) {
        self.provider = provider
    }

    func auth() -> MoyaProvider<SurveyApi>.RequestClosure {
        return { (endpoint, closure) in
            do {
                var request = try endpoint.urlRequest()
                if let session = Session.current, session.isValid() {
                    request.update(session: session)
                    closure(.success(request))
                    return
                } else {
                    self.provider.request(.auth) { result in
                        switch result {
                        case .success(let value):
                            guard let session: Session = try? JSONDecoder().decode(Session.self, from: value.data) else {
                                closure(.failure(MoyaError.encodableMapping(Define.Error.Service.mapping)))
                                return
                            }
                            Session.current = session
                            request.update(session: session)
                            closure(.success(request))
                        case .failure(let error):
                            closure(.failure(error))
                        }
                    }
                }
            } catch MoyaError.requestMapping(let url) {
                closure(.failure(MoyaError.requestMapping(url)))
            } catch MoyaError.parameterEncoding(let error) {
                closure(.failure(MoyaError.parameterEncoding(error)))
            } catch {
                closure(.failure(MoyaError.underlying(error, nil)))
            }
        }
    }
}
