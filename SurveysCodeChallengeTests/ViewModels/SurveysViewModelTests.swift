//
//  SurveysViewModelTests.swift
//  SurveysCodeChallengeTests
//
//  Created by Su Nguyen on 11/25/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import Quick
import Nimble
@testable import SurveysCodeChallenge

final class SurveysViewModelTests: QuickSpec {

    override func spec() {
        testsFetchSurveys()
        testsLoadMore()
        testsShouldLoadMore()
        testsGetItemViewModel()
    }

    func testsGetItemViewModel() {
        let mockSurveyProvider = MockSurveyProvider()
        var viewModel = SurveysViewModel(provider: mockSurveyProvider)

        describe("Giving a SurveysViewModel") {
            beforeEach {
                viewModel = SurveysViewModel(provider: mockSurveyProvider)
            }

            context("and surveys are empty and get 1st item view model") {
                it("should throw indexOutOfRange error") {
                    expect(viewModel.numberOfItems()) == 0
                    expect {
                        try viewModel.viewModelForItem(at: 0)
                        }.to(throwError(Define.Error.Data.indexOutOfRange))
                }
            }

            context("and there are 10 surveys") {
                beforeEach {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = false
                    viewModel.fetch()
                }

                it("when get 1st item view model should return a survey item") {
                    expect(viewModel.numberOfItems()) == 10
                    expect {
                        try viewModel.viewModelForItem(at: 0)
                        }.toNot(throwError(Define.Error.Data.indexOutOfRange))
                }

                it("when get 12st item view model should throw indexOutOfRange error") {
                    expect(viewModel.numberOfItems()) == 10
                    expect {
                        try viewModel.viewModelForItem(at: 12)
                        }.to(throwError(Define.Error.Data.indexOutOfRange))
                }
            }
        }
    }

    func testsShouldLoadMore() {
        let mockSurveyProvider = MockSurveyProvider()
        var viewModel = SurveysViewModel(provider: mockSurveyProvider)

        describe("Giving a SurveysViewModel") {
            context("and surveys are empty") {
                beforeEach {
                    viewModel = SurveysViewModel(provider: mockSurveyProvider)
                }

                it("should not load more") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = false
                    expect(viewModel.shouldLoadMore(at: IndexPath(item: 0, section: 0))) == false
                }
            }
        }

        describe("Giving a SurveysViewModel and there are 10 surveys") {
            beforeEach {
                viewModel = SurveysViewModel(provider: mockSurveyProvider)
                viewModel.fetch()
            }

            context("when scroll to 5th item") {

                it("should not load more") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = false
                    expect(viewModel.shouldLoadMore(at: IndexPath(item: 4, section: 0))) == false
                }
            }

            context("when scroll to 7th item") {

                it("should load more") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = false
                    expect(viewModel.shouldLoadMore(at: IndexPath(item: 6, section: 0))) == true
                }
            }
        }
    }

    func testsLoadMore() {
        let mockSurveyProvider = MockSurveyProvider()
        var viewModel = SurveysViewModel(provider: mockSurveyProvider)
        var numberOfSurveys = viewModel.numberOfItems()

        describe("Giving a SurveysViewModel") {
            context("and load more of surveys is successful") {
                beforeEach {
                    viewModel = SurveysViewModel(provider: mockSurveyProvider)
                    viewModel.fetch(completion: {
                        numberOfSurveys = viewModel.numberOfItems()
                    })
                }

                it("should get an array of correct response") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = false

                    viewModel.fetch(isLoadMore: true, completion: {
                        expect(viewModel.numberOfItems()) == 20
                        expect(viewModel.numberOfItems()) > numberOfSurveys
                    })
                }

                it("should get an empty response") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = true

                    viewModel.fetch(isLoadMore: true, completion: {
                        expect(viewModel.numberOfItems()) == 10
                        expect(viewModel.numberOfItems()) == numberOfSurveys
                    })
                }
            }
        }
    }

    func testsFetchSurveys() {
        let mockSurveyProvider = MockSurveyProvider()
        var viewModel = SurveysViewModel(provider: mockSurveyProvider)

        describe("Giving a SurveysViewModel") {
            context("and fetch of surveys is successful") {
                beforeEach {
                    viewModel = SurveysViewModel(provider: mockSurveyProvider)
                }

                it("should get an array of correct response") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = false

                    viewModel.fetch(completion: {
                        expect(viewModel.numberOfItems()) == 10
                    })
                }

                it("should get empty response") {
                    mockSurveyProvider.shouldSuccess = true
                    mockSurveyProvider.isEmptyData = true

                    viewModel.fetch(completion: {
                        expect(viewModel.numberOfItems()) == 0
                    })
                }

            }

            context("and fetch of surveys is failure") {
                it("should get an error response") {
                    mockSurveyProvider.shouldSuccess = false

                    viewModel.fetch(completion: {
                        expect(viewModel.numberOfItems()) == 0
                    })
                }
            }
        }
    }
}
