//
//  GBKProgressButton+Helpers.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 1/13/21.
//

import Foundation

// MARK: - Paths

public extension GBKProgressButton {

    var circlePath: UIBezierPath {
        let path = UIBezierPath()
        path.lineWidth = lineWidth
        path.addArc(withCenter: viewCenter, radius: circleRadius, startAngle: .pi * 1.5, endAngle: .pi * 3.5, clockwise: true)
        return path
    }

    var borderPath: UIBezierPath {
        UIBezierPath(roundedRect: bounds, cornerRadius: buttonCorners)
    }
}

// MARK: - Coordinates

public extension GBKProgressButton {

    var circleRadius: CGFloat {
        let minSize = min(bounds.maxY, bounds.maxX)
        return (minSize / 2)
    }

    var viewCenter: CGPoint {
        guard let center = superview?.convert(center, to: self) else {
            return .zero
        }
        return center
    }
}

