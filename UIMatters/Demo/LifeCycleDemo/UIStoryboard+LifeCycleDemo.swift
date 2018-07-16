//
//  UIStoryboard+LifeCycleDemo.swift
//  UIMatters
//
//  Created by Haozhe XU on 14/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

extension LifeCycleViewController: UIViewControllerFromStoryboard {}

extension UIStoryboard {

    static var lifeCycleDemoViewController: UIViewController {
        let viewController = LifeCycleViewController.make(from: Constants.storyboardName)
        viewController.viewModel = LifeCycleDemoViewModel()
        return viewController
    }

    private enum Constants {
        static let storyboardName = "LifeCycleDemo"
    }
}
