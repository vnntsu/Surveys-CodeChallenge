//
//  SurveysViewModel.swift
//  Surveys-CodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation

protocol SurveysViewModelDelegate: class {
    func viewModel(_ viewModel: SurveysViewModel, needsPerform actions: SurveysViewModel.Action)
}

final class SurveysViewModel {

    private var surveys: [Survey] = []
    private var page: Int = 1

    weak var delegate: SurveysViewModelDelegate?

    func fetch(completion: (() -> Void)? = nil) {
        dummyData()
        delegate?.viewModel(self, needsPerform: .didFetch)
    }

    // WARN: - Dummy Data
    private func dummyData() {
        for index in 0..<10 {
            let survey = Survey(id: "\(index)",
                title: "Dummy Title \(index)",
                description: "Dummy Description \(index)",
                coverImageURL: "")
            surveys.append(survey)
        }
    }
}

// MARK: - DataSource
extension SurveysViewModel {
    func numberOfItems(in section: Int) -> Int {
        return surveys.count
    }

    func viewModelForItem(at index: Int) throws -> SurveyCellViewModel {
        guard surveys.indices.contains(index) else {
            throw Define.Error.indexOutOfRange
        }
        return SurveyCellViewModel(survey: surveys[index])
    }
}

// MARK: - Configuration
extension SurveysViewModel {
    enum Action {
        case didFetch
        case didLoadMore
        case didFail(Error)
        case showLoading(Bool)
    }
}
