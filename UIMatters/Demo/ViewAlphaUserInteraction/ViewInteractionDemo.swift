//
//  ViewInteractionDemo.swift
//  UIMatters
//
//  Created by Haozhe XU on 16/7/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

extension DemoIdentifier {
    static let viewAlphaInteraction = DemoIdentifier(domain: .uiview, name: "Alpha & Interaction")
}

final class ViewInteractionDemo: Demoable {
    
    var identifier: DemoIdentifier {
        return .viewAlphaInteraction
    }
    
    var viewController: UIViewController {
        let viewController = UIStoryboard.alphaInteractionViewController
        return viewController
    }
    
    // MARK: - Private Constants
    
    private enum Constants {
        static let storyboardName = "LifeCycleDemo"
    }
}
