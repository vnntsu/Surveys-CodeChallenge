//
//  MoyaProvider.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Moya

extension MoyaProvider {
    convenience init(refreshToken: Bool) {
        if refreshToken {
            self.init(requestClosure: MoyaProvider<SurveyApi>.endpointResolver)
        } else {
            self.init()
        }
    }

    private class func endpointResolver(for endpoint: Endpoint, closure: @escaping RequestResultClosure) {
        do {
            let urlRequest = try endpoint.urlRequest()
            auth(urlRequest, completion: closure)
        } catch MoyaError.requestMapping(let url) {
            closure(.failure(MoyaError.requestMapping(url)))
        } catch MoyaError.parameterEncoding(let error) {
            closure(.failure(MoyaError.parameterEncoding(error)))
        } catch {
            closure(.failure(MoyaError.underlying(error, nil)))
        }
    }

    private class func auth(_ request: URLRequest, completion: @escaping RequestResultClosure) {
        var request = request
        if let session = Session.current, session.isValid() {
            request.update(session: session)
            completion(.success(request))
        } else {
            MoyaProvider<SurveyApi>().request(.auth) { (result) in
                switch result {
                case .success(let value):
                    guard let session: Session = try? JSONDecoder().decode(Session.self, from: value.data) else {
                        completion(.failure(MoyaError.encodableMapping(Define.Error.Service.mapping)))
                        return
                    }
                    Session.current = session
                    request.update(session: session)
                    completion(.success(request))
                case .failure(let error):
                    completion(.failure(error))
                }
            }
        }
    }
}
