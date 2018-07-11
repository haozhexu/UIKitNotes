//
//  ModalDemoViewModel.swift
//  UIMatters
//
//  Created by Haozhe XU on 13/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

protocol ModalDemoViewModelDelegate {
    func modalDemoViewModel(_ viewModel: ModalDemoViewModel, presentWithPresentationStyle presentationStyle: ModalDemoViewModel.ModalPresentationStyleName, transitionStyle: ModalDemoViewModel.ModalTransitionStyleName)
    func modalDemoViewModel(_ viewModel: ModalDemoViewModel, setPresentButtonHidden hidden: Bool)
}

final class ModalDemoViewModel {

    var delegate: ModalDemoViewModelDelegate?

    // MARK: - Private

    enum ModalPresentationStyleName: String {
        case fullScreen
        case overFullScreen
        case pageSheet
        case formSheet
        case currentContext
        case overCurrentContext
        case popover
    }

    enum ModalTransitionStyleName: String {
        case coverVertical
        case flipHorizontal
        case crossDissolve
        case partialCurl
    }

    private let presentationStyleNames: [ModalPresentationStyleName] = {
        let titles: [ModalPresentationStyleName] = [.fullScreen, .overFullScreen, .pageSheet, .formSheet, .currentContext, .overCurrentContext, .popover]
        return titles
    }()

    private let transitionStyleNames: [ModalTransitionStyleName] = {
        let titles: [ModalTransitionStyleName] = [.coverVertical, .flipHorizontal, .crossDissolve, .partialCurl]
        return titles
    }()

    private static let conflictingStyles: [ModalPresentationStyleName: ModalTransitionStyleName] = {
        return [.overFullScreen: .partialCurl, .pageSheet: .partialCurl, .formSheet: .partialCurl, .currentContext: .partialCurl, .overCurrentContext: .partialCurl, .popover: .partialCurl]
    }()

    private var selectedTransitionStyleRow = 0
    private var selectedPresentationStyleRow = 0

    // MARK: - view model properties

    let pickerViewComponentCount = 1

    var transitionStyleRowCount: Int {
        return transitionStyleNames.count
    }

    var presentationStyleRowCount: Int {
        return presentationStyleNames.count
    }

    func transitionStyleTitle(at row: Int) -> String {
        return transitionStyleNames[row].rawValue
    }

    func presentationStyleTitle(at row: Int) -> String {
        return presentationStyleNames[row].rawValue
    }

    func didSelectTransitionStyle(at row: Int) {
        selectedTransitionStyleRow = row
        validatePresentationAndTransitionStylesPair()
    }

    func didSelectPresentationStyle(at row: Int) {
        selectedPresentationStyleRow = row
        validatePresentationAndTransitionStylesPair()
    }

    func didTapPresent() {
        guard let delegate = delegate else {
            return
        }
        let presentationStyle = presentationStyleNames[selectedPresentationStyleRow]
        let transitionStyle = transitionStyleNames[selectedTransitionStyleRow]
        delegate.modalDemoViewModel(self, presentWithPresentationStyle: presentationStyle, transitionStyle: transitionStyle)
    }

    // MARK: - Private methods

    func validatePresentationAndTransitionStylesPair() {
        guard let delegate = delegate else {
            return
        }

        let presentationStyle = presentationStyleNames[selectedPresentationStyleRow]
        let transitionStyle = transitionStyleNames[selectedTransitionStyleRow]
        let isValidPair = ModalDemoViewModel.isValid(presentationStyle: presentationStyle, transitionStyle: transitionStyle)
        delegate.modalDemoViewModel(self, setPresentButtonHidden: isValidPair == false)
    }
    
    static func isValid(presentationStyle: ModalPresentationStyleName, transitionStyle: ModalTransitionStyleName) -> Bool {
        return conflictingStyles.first { (presentation, transition) in
            presentationStyle == presentation && transitionStyle == transition
        } == nil
    }
}
