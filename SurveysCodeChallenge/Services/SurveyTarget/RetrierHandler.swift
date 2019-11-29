//
//  RetrierHandler.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/28/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Moya
import Alamofire

final class RetrierHandler: RequestRetrier, RequestAdapter {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse {
            if response.isAuthExpired {
                AuthProvider().auth(completion: { result in
                    switch result {
                    case .success(let isAuthSuccess):
                        if var request = request.task?.currentRequest {
                            request.update(session: Session.current)
                        }
                        completion(isAuthSuccess, 0.0)
                    case .failure: completion(false, 0.0)
                    }
                })
            } else {
                completion(false, 0.0)
            }
        }
    }

    func adapt(_ urlRequest: URLRequest) throws -> URLRequest {
        var urlRequest = urlRequest
        urlRequest.update(session: Session.current)
        return urlRequest
    }
}

// MARK: - Check auth is expired
private extension HTTPURLResponse {
    var isAuthExpired: Bool {
        return statusCode == 401
    }
}
