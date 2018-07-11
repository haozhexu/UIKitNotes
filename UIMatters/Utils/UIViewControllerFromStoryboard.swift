//
//  UIViewControllerFromStoryboard.swift
//  UIMatters
//
//  Created by Haozhe XU on 13/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

protocol UIViewControllerFromStoryboard {
    static func make(from storyboardNameOrNil: String?) -> Self
}

extension UIViewControllerFromStoryboard where Self: UIViewController {
    static func make(from storyboardNameOrNil: String? = nil) -> Self {
        let storyboardName = storyboardNameOrNil ?? self.className
        let storyboard = UIStoryboard(name: storyboardName, bundle: Bundle(for: Self.self))
        return storyboard.instantiateViewController(withIdentifier: self.className) as! Self
    }
    
    static private var className: String {
        return String(describing: self)
    }
}
