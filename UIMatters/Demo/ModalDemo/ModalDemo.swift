//
//  ModalDemo.swift
//  UIMatters
//
//  Created by Haozhe XU on 5/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

extension DemoIdentifier {
    static let modal = DemoIdentifier(domain: .uiviewcontroller, name: "Modal")
}

final class ModalDemo: Demoable {

    let title = "Modal Demo"
    let identifier = DemoIdentifier.modal

    var viewController: UIViewController {
        return UIStoryboard.modalDemoViewController
    }

    // MARK: - Private Constants

    private enum Constants {
        static let storyboardName = "ModalDemo"
    }
}
