//
//  ViewController.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 10/23/2020.
//  Copyright (c) 2020 Roman Mizin. All rights reserved.
//

import UIKit
import GBKProgressButton

class ViewController: UIViewController {

    private enum Constants {
        static let cellID = String(describing: TableViewCell.self)
    }
    
    @IBOutlet weak var tableView: UITableView!

    var dataSource: [Model] = [
        Model(), Model(), Model(), Model(), Model(),
        Model(), Model(), Model(), Model(), Model(),
        Model(), Model(), Model(), Model(), Model(),
        Model(), Model(), Model(), Model(), Model(),
        Model(), Model(), Model(), Model(), Model(),
        Model(), Model(), Model(), Model(), Model(),
        Model(), Model(), Model(), Model(), Model()
    ]

    override func viewDidLoad() {
        super.viewDidLoad()
        configureTableView()
    }
}

// MARK: Configuration

private extension ViewController {

    func configureTableView() {
        tableView.register(UINib(nibName: Constants.cellID, bundle: nil), forCellReuseIdentifier: Constants.cellID)
    }
}

// MARK: - UITableViewDelegate, UITableViewDataSource

extension ViewController: UITableViewDelegate, UITableViewDataSource {

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        dataSource.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellID) as? TableViewCell else {
            preconditionFailure()
        }

        cell.delegate = self
        cell.configure(model: dataSource[indexPath.row])
        return cell
    }
}

// MARK: - TableViewCellDelegate

extension ViewController: TableViewCellDelegate {

    func tableViewCell(_ cell: TableViewCell, didTapDownload button: GBKProgressButton) {

        guard let indexPath = tableView.indexPath(for: cell) else {
            return
        }

        let operation = MediaDownloadTasksObserverDataObject(id: dataSource[indexPath.row].id)

        if !DownloadService.shared.mediaDownloadDataTasks.contains(where: { $0.id == dataSource[indexPath.row].id }) {
            DownloadService.shared.mediaDownloadDataTasks.insert(operation)
            operation.startDownloading()
        }
    }
}
