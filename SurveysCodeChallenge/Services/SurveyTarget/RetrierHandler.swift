//
//  RetrierHandler.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/28/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Moya
import Alamofire

final class RetrierHandler: RequestRetrier {
    func should(_ manager: SessionManager, retry request: Request, with error: Error, completion: @escaping RequestRetryCompletion) {
        if let response = request.task?.response as? HTTPURLResponse {
            if response.isAuthExpired {
                AuthProvider().auth { result in
                    switch result {
                    case .success(let isAuthSuccess): completion(isAuthSuccess, 0.0)
                    case .failure: completion(false, 0.0)
                    }
                }
            }
            completion(false, 0.0)
        }
    }
}

// MARK: - Check auth is expired
private extension HTTPURLResponse {
    var isAuthExpired: Bool {
        return statusCode == 401
    }
}
