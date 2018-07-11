//
//  DemoViewModel.swift
//  UIMatters
//
//  Created by Haozhe XU on 6/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import Foundation
import UIKit

protocol DemoViewModelDelegate {
    func demoViewModel(_ viewModel: DemoViewModel, showViewController viewController: UIViewController)
}

final class DemoViewModel {
    
    private lazy var demoables: [Demoable] = {
        return [ModalDemo(), LifeCycleDemo()]
    }()
    
    let numberOfSections = 1
    var numberOfRows: Int {
        return demoables.count
    }
    
    var delegate: DemoViewModelDelegate?
    
    func cellViewModel(at indexPath: IndexPath) -> DemoCellViewModel {
        let demoable = demoables[indexPath.row]
        return DemoCellViewModel(title: demoable.title, accessibilityIdentifier: demoable.identifier)
    }
    
    func didSelectCell(at indexPath: IndexPath) {
        if let delegate = delegate {
            let demoable = demoables[indexPath.row]
            delegate.demoViewModel(self, showViewController: demoable.viewController)
        }
    }
}

struct DemoCellViewModel {
    let title: String
    let accessibilityIdentifier: String
}
