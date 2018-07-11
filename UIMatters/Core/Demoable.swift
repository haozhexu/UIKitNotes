//
//  Demoable.swift
//  UIMatters
//
//  Created by Haozhe XU on 5/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

protocol Demoable {
    var viewController: UIViewController { get }
    var title: String { get }
    var identifier: String { get }
}
