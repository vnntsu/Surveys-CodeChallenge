//
//  SurveysViewController.swift
//  Surveys-CodeChallenge
//
//  Created by Su Nguyen on 11/23/19.
//  Copyright © 2019 Su Nguyen. All rights reserved.
//

import UIKit

final class SurveysViewController: UIViewController {
    @IBOutlet private weak var collectionView: UICollectionView!
    @IBOutlet private weak var takeSurveyButton: UIButton!
    @IBOutlet private weak var pageContainerView: UIView!
    @IBOutlet private weak var pageControl: ISPageControl!

    var viewModel: SurveysViewModel = SurveysViewModel()

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == Configure.showDetailIdentifier, let controller = segue.destination as? SurveyDetailViewController {
            guard let detailViewModel = try? viewModel.viewModelForItem(at: pageControl.currentPage) else { return }
            controller.viewModel = detailViewModel
        }
    }

    override func viewDidLoad() {
        super.viewDidLoad()
        configUI()
        setupData()
    }

    private func configUI() {
        takeSurveyButton.layer.cornerRadius = takeSurveyButton.height / 2
        configCollectionView()
        configPageControl()
    }

    private func configCollectionView() {
        let layout = UICollectionViewFlowLayout()
        let cellWidth = Define.screenSize.width
        let navigationBarHeight: CGFloat = navigationController?.navigationBar.height ?? 0
        let cellHeight = Define.screenSize.height - navigationBarHeight - Define.statusBarHeight
        layout.itemSize = CGSize(width: cellWidth, height: cellHeight)
        layout.minimumLineSpacing = .leastNonzeroMagnitude
        collectionView.setCollectionViewLayout(layout, animated: true)
    }

    private func configPageControl() {
        let trailingConstant = (Define.screenSize.width - pageControl.height) / 2
        let trailingAnchor = pageContainerView
            .trailingAnchor
            .constraint(equalTo: view.trailingAnchor,
                        constant: trailingConstant)
        trailingAnchor.isActive = true
        pageContainerView.transform = CGAffineTransform(rotationAngle: CGFloat.pi / 2)
    }

    private func setupData() {
        viewModel.delegate = self

        viewModel.fetch()
    }

    private func updateUI() {
        collectionView.reloadData()
        pageControl.numberOfPages = viewModel.numberOfItems()
        takeSurveyButton.isHidden = viewModel.numberOfItems() <= 0
    }

    private func refreshUI() {
        collectionView.reloadData()
        collectionView.setContentOffset(.zero, animated: false)
        pageControl.numberOfPages = viewModel.numberOfItems()
        takeSurveyButton.isHidden = viewModel.numberOfItems() <= 0
    }
}

// MARK: - Actions
extension SurveysViewController {
    @IBAction private func didTapRefreshButton() {
        viewModel.fetch()
    }

    @IBAction private func didTapMenuButton() {
        showAuthor()
    }
}

// MARK: - SurveysViewModelDelegate
extension SurveysViewController: SurveysViewModelDelegate {
    func viewModel(_ viewModel: SurveysViewModel, needsPerform actions: SurveysViewModel.Action) {
        switch actions {
        case .didFetch:
            refreshUI()
        case .didLoadMore:
            updateUI()
        case .didFail(let error):
            showError(error)
        case .showLoading(let isShow):
            indicator(shouldShow: isShow)
        }
    }
}

// MARK: - UICollectionViewDelegate
extension SurveysViewController: UICollectionViewDelegate {
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        let offset = scrollView.height
        let index = Int((scrollView.contentOffset.y / offset).rounded())
        pageControl.currentPage = index
    }

    func collectionView(_ collectionView: UICollectionView, willDisplay cell: UICollectionViewCell, forItemAt indexPath: IndexPath) {
        if viewModel.shouldLoadMore(at: indexPath) {
            viewModel.fetch(isLoadMore: true)
        }
    }
}

// MARK: - UICollectionViewDataSource
extension SurveysViewController: UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return viewModel.numberOfItems(in: section)
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        guard let cellViewModel = try? viewModel.cellViewModelForItem(at: indexPath.item) else { return UICollectionViewCell() }
        let cell = collectionView.dequeue(withClass: SurveyCell.self, for: indexPath)
        cell.configure(with: cellViewModel)
        return cell
    }
}

// MARK: - Define
extension SurveysViewController {
    private struct Configure {
        static let showDetailIdentifier: String = "ShowSurveyDetail"
    }
}
