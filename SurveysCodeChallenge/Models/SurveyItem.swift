//
//  SurveyItem.swift
//  SurveysCodeChallenge
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

final class SurveyItem {
    private var survey: Survey

    var title: String {
        return survey.title.trimmed
    }
    var description: String {
        return survey.description.trimmed
    }
    var imagePath: String {
        return survey.coverImageURL + "l"
    }

    init(survey: Survey) {
        self.survey = survey
    }
}
