//
//  DownloadService.swift
//  GBKProgressButton_Example
//
//  Created by Roman Mizin on 10/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation

@objc class DownloadService: NSObject {

    static let shared = DownloadService()

    @objc dynamic var mediaDownloadDataTasks = Set<MediaDownloadTasksObserverDataObject>()

    func downloadOperation(at id: String) -> MediaDownloadTasksObserverDataObject? {
        mediaDownloadDataTasks.first(where: { $0.id == id })
    }

    public func observeMediaDownloadTask(id: String, _ block: ((_ data: MediaDownloadTasksObserverDataObject?)->())?) -> NSKeyValueObservation {
        return DownloadService.shared.observe(\.mediaDownloadDataTasks, options: [.initial, .new], changeHandler: { (object, change) in
            guard let data = change.newValue, let index = data.firstIndex(where: { $0.id == id }) else { return }
            block?(data[index])
        })
    }
}
