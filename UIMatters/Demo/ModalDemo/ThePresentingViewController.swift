//
//  DemoModalViewController.swift
//  UIMatters
//
//  Created by Haozhe XU on 5/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

class ThePresentingViewController: UIViewController {

    // MARK: - Outlets

    @IBOutlet weak var transitionStylePicker: UIPickerView!
    @IBOutlet weak var presentationStylePicker: UIPickerView!
    @IBOutlet weak var presentButton: UIButton!
    @IBOutlet weak var infoLabel: UILabel!

    // MARK: - Private

    var viewModel: ModalDemoViewModel!

    // MARK: - View Controller Life Cycle

    override func viewDidLoad() {
        super.viewDidLoad()
        precondition(viewModel != nil)
        viewModel.delegate = self
        configureInfo()
    }
    
    // MARK: - Private functions
    private func configureInfo() {
        var info: String = ""
        if let parent = parent {
            let parentClassName = NSStringFromClass(type(of: parent))
            info.append("self.parent is of type: \n\(parentClassName)\n\n")
        } else {
            info.append("self.parent is nil\n\n")
        }
        
        if let presentingViewController = presentingViewController {
            let presentingVCClassName = NSStringFromClass(type(of: presentingViewController))
            info.append("\nself.presentingViewController is of type:\n\(presentingVCClassName)")
        } else {
            info.append("self.presentingViewController is nil")
        }
        infoLabel.text = info
    }

    // MARK: - Actions

    @IBAction func presentAction(_ sender: AnyObject?) {
        viewModel.didTapPresent()
    }
}

// MARK: - UIPickerViewDataSource

extension ThePresentingViewController: UIPickerViewDataSource {

    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return viewModel.pickerViewComponentCount
    }

    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView === presentationStylePicker {
            return viewModel.presentationStyleRowCount
        } else if pickerView === transitionStylePicker {
            return viewModel.transitionStyleRowCount
        }
        preconditionFailure()
    }
}

// MARK: - UIPickerViewDelegate

extension ThePresentingViewController: UIPickerViewDelegate {

    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView === presentationStylePicker {
            return viewModel.presentationStyleTitle(at: row)
        } else if pickerView === transitionStylePicker {
            return viewModel.transitionStyleTitle(at: row)
        }
        preconditionFailure()
    }

    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView === presentationStylePicker {
            viewModel.didSelectPresentationStyle(at: row)
        } else if pickerView === transitionStylePicker {
            viewModel.didSelectTransitionStyle(at: row)
        } else {
            preconditionFailure()
        }
    }
}

// MARK: - ModalDemoViewControllerDelegate

extension ThePresentingViewController: ModalDemoViewModelDelegate {

    func modalDemoViewModel(_ viewModel: ModalDemoViewModel, presentWithPresentationStyle presentationStyle: ModalDemoViewModel.ModalPresentationStyleName, transitionStyle: ModalDemoViewModel.ModalTransitionStyleName) {
        let viewController = UIStoryboard.modalDemoViewController
        viewController.navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(modalDoneAction(_:)))
        let navigationController = UINavigationController(rootViewController: viewController)
        navigationController.modalTransitionStyle = transitionStyle.modalTransitionStyle
        navigationController.modalPresentationStyle = presentationStyle.modalPresentationStyle
        navigationController.popoverPresentationController?.sourceView = self.presentButton
        present(navigationController, animated: true, completion: nil)
    }

    func modalDemoViewModel(_ viewModel: ModalDemoViewModel, setPresentButtonHidden hidden: Bool) {
        presentButton.isHidden = hidden
    }

    @objc
    func modalDoneAction(_ sender: AnyObject?) {
        dismiss(animated: true, completion: nil)
    }
}

extension ModalDemoViewModel.ModalPresentationStyleName {

    var modalPresentationStyle: UIModalPresentationStyle {
        switch self {
        case .fullScreen:
            return .fullScreen
        case .overFullScreen:
            return .overFullScreen
        case .pageSheet:
            return .pageSheet
        case .formSheet:
            return .formSheet
        case .currentContext:
            return .currentContext
        case .overCurrentContext:
            return .overCurrentContext
        case .popover:
            return .popover
        }
    }
}

extension ModalDemoViewModel.ModalTransitionStyleName {

    var modalTransitionStyle: UIModalTransitionStyle {
        switch self {
        case .coverVertical:
            return .coverVertical
        case .flipHorizontal:
            return .flipHorizontal
        case .crossDissolve:
            return .crossDissolve
        case .partialCurl:
            return .partialCurl
        }
    }
}
