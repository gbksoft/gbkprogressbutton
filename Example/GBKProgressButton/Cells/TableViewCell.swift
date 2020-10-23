//
//  TableViewCell.swift
//  GBKProgressButton_Example
//
//  Created by Roman Mizin on 10/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import UIKit
import GBKProgressButton

protocol TableViewCellDelegate: class {
    func tableViewCell(_ cell: TableViewCell, didTapDownload button: GBKProgressButton)
}

class TableViewCell: UITableViewCell {

    private enum Constants {
        static let download = "Download"
        static let open = "Open"
    }

    @IBOutlet private weak var progressButton: GBKProgressButton!

    weak var delegate: TableViewCellDelegate?

    private var downloadObservation: NSKeyValueObservation?
    private var downloadProgressObservation: NSKeyValueObservation?

    override func prepareForReuse() {
        super.prepareForReuse()
        downloadObservation?.invalidate()
        downloadProgressObservation?.invalidate()

        progressButton.prepareForReuse()
        progressButton.titleText = Constants.download
    }

    @IBAction func progressButtonDidTap(_ sender: GBKProgressButton) {
        delegate?.tableViewCell(self, didTapDownload: sender)
    }

    func configure(model: Model) {

        if let currentDownloadState = DownloadService.shared.downloadOperation(at: model.id) {

            switch currentDownloadState.state {
            case .finished:
                progressButton.titleText = Constants.open
                return
            case .initiated:
                progressButton.animate(to: currentDownloadState.progress, animated: false)
            case .notInitiated:
                progressButton.titleText = Constants.download
            }
        } else {
            progressButton.titleText = Constants.download
        }

        downloadObservation = DownloadService.shared.observeMediaDownloadTask(id: model.id, { [weak self] (object) in
            self?.downloadProgressObservation = object?.observe(\.progress, options: [.new], changeHandler: { [weak self] (object, change) in
                guard let progress = change.newValue else {
                    return
                }

                self?.progressButton.animate(to: progress, downloaded: { [weak self] in
                    self?.progressButton.titleText = Constants.open
                })
            })
        })
    }
}
