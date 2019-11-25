//
//  SurveyTests.swift
//  SurveysCodeChallengeTests
//
//  Created by Su Nguyen on 11/26/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Quick
import Nimble
@testable import SurveysCodeChallenge

class SurveyTests: QuickSpec {
    override func spec() {
        super.spec()
        describe("Giving survey") {
            let survey: Survey = .survey

            context("when initializing with dummy data") {
                it("should be expected each properties") {
                    expect(survey.id) == "surveyId"
                    expect(survey.title) == "survey title"
                    expect(survey.description) == "survey description"
                    expect(survey.coverImageURL) == "coverImageURL"
                }
            }
        }
    }
}
