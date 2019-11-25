//
//  MoyaProvider.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Moya

extension MoyaProvider {
    convenience init(handleRefreshToken: Bool) {
        if handleRefreshToken {
            self.init(requestClosure: MoyaProvider.endpointResolver())
        } else {
            self.init()
        }
    }

    static func endpointResolver() -> MoyaProvider<Target>.RequestClosure {
        return AuthProvider(provider: MoyaProvider<SurveyApi>()).auth()
    }
}
