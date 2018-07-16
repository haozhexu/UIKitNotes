//
//  UIStoryboard+ViewAlphaUserInteraction.swift
//  UIMatters
//
//  Created by Haozhe XU on 16/7/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

extension AlphaInteractionViewController: UIViewControllerFromStoryboard {}

extension UIStoryboard {

    static var alphaInteractionViewController: UIViewController {
        return AlphaInteractionViewController.make(from: Constants.storyboardName)
    }
    
    private enum Constants {
        static let storyboardName = "AlphaInteractionDemo"
    }
}
