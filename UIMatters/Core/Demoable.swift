//
//  Demoable.swift
//  UIMatters
//
//  Created by Haozhe XU on 5/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

struct DemoIdentifier {

    struct Domain: RawRepresentable {

        typealias RawValue = String
        
        var rawValue: String
        
        init(rawValue: String) {
            self.rawValue = rawValue
        }
    }

    let domain: Domain
    let name: String

    init(domain: Domain, name: String) {
        self.domain = domain
        self.name = name
    }
}

protocol Demoable {
    var identifier: DemoIdentifier { get }
    var viewController: UIViewController { get }
}
