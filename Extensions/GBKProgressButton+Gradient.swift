//
//  GBKProgressButton+Gradient.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 1/13/21.
//

import Foundation

// MARK: - Gradient

public extension GBKProgressButton {

    func configureGradient() {
        guard let topColor = gradientTopColor, let bottomColor = gradientBottomColor else {
            return
        }

        let layer = self.layer as? CAGradientLayer
        layer?.startPoint = gradientStartPoint
        layer?.endPoint = gradientEndPoint
        layer?.colors = animationState == .none ? [
            topColor.withAlphaComponent(gradientOpacity).cgColor,
            bottomColor.withAlphaComponent(gradientOpacity).cgColor
        ] : []
    }

    //Gradient color
    func color() -> UIColor {

        guard let topColor = gradientTopColor, let bottomColor = gradientBottomColor else {
            return primaryColor
        }

        let backgroundGradientLayer = CAGradientLayer()
        backgroundGradientLayer.frame = bounds
        backgroundGradientLayer.startPoint = gradientStartPoint
        backgroundGradientLayer.endPoint = gradientEndPoint

        let cgColors = [topColor, bottomColor].map({ $0.cgColor })
        backgroundGradientLayer.colors = cgColors
        UIGraphicsBeginImageContextWithOptions(backgroundGradientLayer.bounds.size, false, UIScreen.main.scale)
        if let context = UIGraphicsGetCurrentContext() {
            backgroundGradientLayer.render(in: context)
        }

        let backgroundColorImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return UIColor(patternImage: backgroundColorImage ?? UIImage())
    }
}
