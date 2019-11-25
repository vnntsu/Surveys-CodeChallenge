//
//  SurveyItemTests.swift
//  SurveysCodeChallengeTests
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Quick
import Nimble
@testable import SurveysCodeChallenge

final class SurveyItemTests: QuickSpec {

    override func spec() {
        let viewModel = SurveyItem(survey: Survey.survey)

        describe("Giving a survey item") {
            context("when get data") {
                it("should return exactly data") {
                    expect(viewModel.title) == "survey title"
                    expect(viewModel.description) == "survey description"
                    expect(viewModel.imagePath) == "coverImageURL" + "l"
                }
            }
        }
    }
}
