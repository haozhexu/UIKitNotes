//
//  DemoViewController.swift
//  UIMatters
//
//  Created by Haozhe XU on 25/4/18.
//  Copyright © 2018 Haozhe XU. All rights reserved.
//

import UIKit

class DemoViewController: UIViewController {

    private enum Constants {
        static let cellIdentifier = "CellIdentifier"
    }

    @IBOutlet weak var tableView: UITableView!

    let viewModel = DemoViewModel()

    override func viewDidLoad() {
        super.viewDidLoad()
        viewModel.delegate = self
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: Constants.cellIdentifier)
        Logger.shared.output = self
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let selectedIndexPath = tableView.indexPathForSelectedRow {
            tableView.deselectRow(at: selectedIndexPath, animated: true)
        }
    }
}

extension DemoViewController: UITableViewDataSource {

    func numberOfSections(in tableView: UITableView) -> Int {
        return viewModel.numberOfSections
    }

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return viewModel.numberOfRows
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        cell.textLabel?.text = viewModel.cellTitle(at: indexPath)
        return cell
    }
}

extension DemoViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        viewModel.didSelectCell(at: indexPath)
    }
}

extension DemoViewController: DemoViewModelDelegate {

    func demoViewModel(_ viewModel: DemoViewModel, showViewController viewController: UIViewController) {
        navigationController?.pushViewController(viewController, animated: true)
    }
}

extension DemoViewController: LoggerOutput {

    func write(message: String) {
        print(message)
    }
}
