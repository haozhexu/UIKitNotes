//
//  UIStoryboard+ModalDemo.swift
//  UIMatters
//
//  Created by Haozhe XU on 13/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

extension ThePresentingViewController: UIViewControllerFromStoryboard {}

extension UIStoryboard {
    
    static var modalDemoViewController: UIViewController {
        let viewController = ThePresentingViewController.make(from: Constants.storyboardName)
        viewController.viewModel = ModalDemoViewModel()
        return viewController
    }
    
    private enum Constants {
        static let storyboardName = "ModalDemo"
    }
}
