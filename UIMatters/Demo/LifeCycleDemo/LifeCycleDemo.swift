//
//  LifeCycleDemo.swift
//  UIMatters
//
//  Created by Haozhe XU on 13/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

extension DemoIdentifier {
    static let lifeCycle = DemoIdentifier(domain: .uiviewcontroller, name: "Life Cycle")
}

final class LifeCycleDemo: Demoable {

    let identifier = DemoIdentifier.lifeCycle

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
