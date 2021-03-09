//
//  AnimationSettings.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 10/21/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import Foundation

final class AnimationSettings {

    enum State: String {
        case none
        case borderToCircle
        case circleRotation
        case rotateToEnd
        case downloading
    }

    enum Key: String {
        case backgroundColorChange
        case borderStrokeEnd
        case downloadingLineStrokeEnd
        case circleTransformRotation
        case downloadindAnimation
    }

    enum KeyPath: String {
        case backgroundColor
        case strokeEnd
        case strokeStart
        case strokeColor
        case transformRotation = "transform.rotation"
    }

    var duration: Double = 0.5
}
