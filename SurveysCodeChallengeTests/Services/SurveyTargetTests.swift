//
//  SurveyTargetTests.swift
//  SurveysCodeChallengeTests
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Quick
import Nimble
import Moya
import Result
@testable import SurveysCodeChallenge

final class SurveyTargetTests: QuickSpec {

    override func spec() {
        var provider: MoyaProvider<SurveyApi>!
        describe("A Moya Provider with SurveyApi") {
            context("when the response is failure") {
                beforeEach {
                    provider = MoyaProvider<SurveyApi>(endpointClosure: SurveyTargetTests.failureEndpointClosure,
                                                          stubClosure: MoyaProvider.immediatelyStub)
                }
                it("can not get access token") {
                    waitUntil(timeout: Configure.timeout, action: { done in
                        provider.request(.auth, completion: { result in
                            if case Result<Moya.Response, MoyaError>.failure(let error) = result {
                                expect(error).notTo(beNil())
                            }
                            done()
                        })
                    })
                }

                it("can not get surveys") {
                    waitUntil(timeout: Configure.timeout, action: { done in
                        provider.request(.surveys(page: 0, perPage: 10), completion: { result in
                            if case Result<Moya.Response, MoyaError>.failure(let error) = result {
                                expect(error).notTo(beNil())
                            }
                            done()
                        })
                    })
                }
            }

            context("when the response is success") {
                beforeEach {
                    provider = MoyaProvider<SurveyApi>(endpointClosure: SurveyTargetTests.successEndpointClosure,
                                                       requestClosure: MoyaProvider<SurveyApi>().requestClosure,
                                                       stubClosure: MoyaProvider.immediatelyStub)
                }

                it("has access token as expected") {
                    waitUntil(timeout: Configure.timeout, action: { done in
                        provider.request(.auth, completion: { result in
                            if case Result<Moya.Response, MoyaError>.success(let value) = result {
                                let token = try? JSONDecoder().decode(Session.self, from: value.data)
                                expect(token).notTo(beNil())
                            }
                            done()
                        })
                    })
                }

                it("has value for surveys as expected") {
                    waitUntil(timeout: Configure.timeout, action: { done in
                        provider.request(.surveys(page: 0, perPage: 10), completion: { result in
                            if case Result<Moya.Response, MoyaError>.success(let value) = result {
                                let surveys = try? JSONDecoder().decode([Survey].self, from: value.data)
                                expect(surveys).notTo(beNil())
                                expect(surveys?.count) == 8
                            }
                            done()
                        })
                    })
                }
            }
        }
    }
}

// MARK: - Configuration
extension SurveyTargetTests {
    class func successEndpointClosure(_ target: SurveyApi) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkResponse(200, target.sampleData) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    class func failureEndpointClosure(_ target: SurveyApi) -> Endpoint {
        return Endpoint(url: URL(target: target).absoluteString,
                        sampleResponseClosure: { .networkError(Define.Error.Service.mapping as NSError) },
                        method: target.method,
                        task: target.task,
                        httpHeaderFields: target.headers)
    }

    enum Configure {
        static let timeout: TimeInterval = 5
    }
}

// MARK: - Dummy Data
private extension SurveyApi {
    var sampleData: Data {
        switch self {
        case .auth:
            if let data = try? Data(forResource: "Token-Success",
                                    withExtension: "json",
                                    bundle: Bundle(for: SurveyTargetTests.self)) {
                return data
            }
        case .surveys:
            if let data = try? Data(forResource: "Surveys-Success",
                                    withExtension: "json",
                                    bundle: Bundle(for: SurveyTargetTests.self)) {
                return data
            }
        }
        return Data()
    }
}

private extension Data {
    init(forResource name: String, withExtension ext: String, bundle: Bundle = Bundle.main) throws {
        guard let url = bundle.url(forResource: name, withExtension: ext) else { throw Define.Error.Data.notFound }
        try self.init(contentsOf: url)
    }
}
