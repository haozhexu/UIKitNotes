//
//  LifeCycleDemo.swift
//  UIMatters
//
//  Created by Haozhe XU on 13/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

final class LifeCycleDemo: Demoable {

    let title = "Life Cycle Demo"
    let identifier = Demo.lifeCycle.identifier

    var viewController: UIViewController {
        let viewController = UIStoryboard.lifeCycleDemoViewController
        if let viewController = viewController as? LifeCycleViewController {
            Logger.shared.output = viewController
        }
        return viewController
    }

    // MARK: - Private Constants

    private enum Constants {
        static let storyboardName = "LifeCycleDemo"
    }
}
