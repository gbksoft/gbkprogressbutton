//
//  MediaDownloadTasksObserverDataObject.swift
//  GBKProgressButton_Example
//
//  Created by Roman Mizin on 10/23/20.
//  Copyright © 2020 CocoaPods. All rights reserved.
//

import Foundation
import CoreGraphics

final class MediaDownloadTasksObserverDataObject: NSObject {

    enum State {
        case notInitiated
        case initiated
        case finished
    }

    private(set) var state: State = .notInitiated
    @objc public dynamic var progress: CGFloat = 0.0

    let id: String

    init(id: String) {
        self.id = id
        super.init()
    }

    override public var hash: Int {
        id.hashValue
    }

    override public func isEqual(_ object: Any?) -> Bool {
        if let rhs = object as? MediaDownloadTasksObserverDataObject {
            return (self.id == rhs.id)
        }
        return false
    }

    static func == (lhs: MediaDownloadTasksObserverDataObject, rhs: MediaDownloadTasksObserverDataObject) -> Bool {
        lhs.id == rhs.id
    }

    func startDownloading() {
        state = .initiated
        self.progress = 0.0

        DispatchQueue.main.asyncAfter(deadline: .now() + 2) { [weak self] in
            self?.progress = 1
            self?.state = .finished
        }
    }
}
