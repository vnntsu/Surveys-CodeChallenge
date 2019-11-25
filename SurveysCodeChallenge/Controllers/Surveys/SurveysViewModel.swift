//
//  SurveysViewModel.swift
//  Surveys-CodeChallenge
//
//  Created by Su Nguyen on 11/24/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Foundation
import Moya

protocol SurveysViewModelDelegate: class {
    func viewModel(_ viewModel: SurveysViewModel, needsPerform actions: SurveysViewModel.Action)
}

final class SurveysViewModel {

    private var surveys: [Survey] = []
    private var page: Int = 1

    private var isLoading: Bool = false {
        didSet {
            delegate?.viewModel(self, needsPerform: .showLoading(isLoading))
        }
    }
    private var cannotLoadMore = false

    private var provider = SurveyProvider(provider: MoyaProvider<SurveyApi>(handleRefreshToken: true))

    weak var delegate: SurveysViewModelDelegate?

    func fetch(isLoadMore: Bool = false, completion: (() -> Void)? = nil) {
        if isLoading, cannotLoadMore { return }
        if !isLoadMore {
            page = 1
            isLoading = true
            surveys = []
        }
        provider.get(page: page, perPage: Configure.itemsPerPage) { [weak self] result in
            guard let this = self else { return }
            if !isLoadMore {
                this.isLoading = false
            }
            switch result {
            case .success(let data):
                this.cannotLoadMore = data.isEmpty
                this.surveys += data
                this.page += 1
                if isLoadMore {
                    this.delegate?.viewModel(this, needsPerform: .didLoadMore)
                } else {
                    this.delegate?.viewModel(this, needsPerform: .didFetch)
                }
            case .failure(let error):
                this.delegate?.viewModel(this, needsPerform: .didFail(error))
            }
            completion?()
        }
    }
}

// MARK: - DataSource
extension SurveysViewModel {
    func numberOfItems(in section: Int = 0) -> Int {
        return surveys.count
    }

    func cellViewModelForItem(at index: Int) throws -> SurveyCellViewModel {
        guard surveys.indices.contains(index) else {
            throw Define.Error.Data.indexOutOfRange
        }
        return SurveyCellViewModel(survey: surveys[index])
    }

    func viewModelForItem(at index: Int) throws -> SurveyDetailViewModel {
        guard surveys.indices.contains(index) else {
            throw Define.Error.Data.indexOutOfRange
        }
        return SurveyDetailViewModel(survey: surveys[index])
    }

    func shouldLoadMore(at indexPath: IndexPath) -> Bool {
        return indexPath.item == surveys.count - 4 && !cannotLoadMore
    }
}

// MARK: - Configuration
extension SurveysViewModel {
    private struct Configure {
        static let itemsPerPage: Int = 10
    }

    enum Action {
        case didFetch
        case didLoadMore
        case didFail(Error)
        case showLoading(Bool)
    }
}
