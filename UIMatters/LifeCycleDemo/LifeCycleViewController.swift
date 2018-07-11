//
//  LifeCycleViewController.swift
//  UIMatters
//
//  Created by Haozhe XU on 14/5/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

class LifeCycleViewController: LoggableViewController, LoggerOutput {
    
    @IBOutlet weak var textLabel: UILabel!
    
    var viewModel: LifeCycleDemoViewModel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        precondition(viewModel != nil)
    }

    // MARK: - Actions

    @IBAction func pushAction(_ sender: AnyObject?) {
        let viewController = UIViewController()
        self.navigationController?.pushViewController(viewController, animated: true)
    }
    
    @IBAction func clearTextAction(_ sender: AnyObject?) {
        textLabel.text = ""
    }
    
    @IBAction func someTextAction(_ sender: AnyObject?) {
        textLabel.text = viewModel.someText
    }
    
    @IBAction func fillTextAction(_ sender: AnyObject?) {
        textLabel.text = viewModel.fillText
    }
    
    // MARK: - LoggerOutput

    func write(message: String) {
        print(message)
    }
}
