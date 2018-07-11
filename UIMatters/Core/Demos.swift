//
//  Demos.swift
//  UIMatters
//
//  Created by Haozhe XU on 6/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation

enum Demo: String {
    case modal
    case lifeCycle
}

extension Demo {
    var identifier: String {
        return "demo." + rawValue
    }
}
