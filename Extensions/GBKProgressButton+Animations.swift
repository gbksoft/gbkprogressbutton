//
//  GBKProgressButton+Animations.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 1/13/21.
//

import Foundation


// MARK: - Animations

public extension GBKProgressButton {

    /// STEP 1: Animating Button to Circle
    func animateBorderToCircle(animated: Bool = true) {
        guard animationState == .none else {
            return
        }

        animationState = .borderToCircle
        let downloadingLineStrokeEndAnimation = getAnimation(
            path: .strokeStart,
            from: 0.85,
            to: 0.15,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .easeIn))

        let borderStrokeEndAnimation = getAnimation(
            path: .strokeEnd,
            from: 1,
            to: 0.1,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .easeOut))

        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        CATransaction.setCompletionBlock { [weak self] in
            if let self = self {
                self.animateCircleRotation()
            }
        }
        buttonBorder.removeAllAnimations()
        downloadingLine.removeAllAnimations()

        if animated {
            buttonBorder.add(borderStrokeEndAnimation, forKey: AnimationSettings.Key.borderStrokeEnd.rawValue)
            downloadingLine.add(downloadingLineStrokeEndAnimation, forKey: AnimationSettings.Key.downloadingLineStrokeEnd.rawValue)
        }

        CATransaction.commit()
    }

    /// STEP 2: Set Created Circle Rotation Animation
    func animateCircleRotation() {
        guard animationState == .borderToCircle else {
            return
        }
        animationState = .circleRotation
        downloadState = .pending
        let circleRotateAnimation = CABasicAnimation(keyPath: "transform.rotation")
        circleRotateAnimation.toValue = 0
        circleRotateAnimation.fromValue = CGFloat.pi * 2
        circleRotateAnimation.duration = 1
        circleRotateAnimation.repeatCount = Float.greatestFiniteMagnitude
        CATransaction.begin()
        downloadingLine.removeAllAnimations()
        downloadingLine.add(circleRotateAnimation, forKey: AnimationSettings.Key.circleTransformRotation.rawValue)
        CATransaction.commit()
    }

    /// STEP 3:  Close Gap In Rotated Line before downloading
    func animateRotateToEnd(animated: Bool = true) {
        guard animationState == .circleRotation else {
            return
        }
        animationState = .rotateToEnd
        let currentRotationAngle = atan2(downloadingLine.presentation()!.transform.m12, downloadingLine.presentation()!.transform.m11)
        let circleRotateAnimation = getAnimation(
            path: .transformRotation,
            from: currentRotationAngle,
            to: 0,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .linear))

        let downloadingLineStrokeEndAnimation = getAnimation(
            path: .strokeStart,
            from: 0.15,
            to: 0,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .linear))

        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        CATransaction.setCompletionBlock { [weak self] in
            self?.downloadState = .downloading
            self?.animationState = .downloading
        }
        downloadingLine.removeAllAnimations()

        if animated {
            downloadingLine.add(downloadingLineStrokeEndAnimation, forKey: AnimationSettings.Key.downloadingLineStrokeEnd.rawValue)
            downloadingLine.add(circleRotateAnimation, forKey: AnimationSettings.Key.circleTransformRotation.rawValue)
        }

        CATransaction.commit()
    }

    /// STEP 4:  Animate Download Progress
    func animateDownloading(value: CGFloat, animated: Bool = true, downloaded: (() -> Void)? = nil) {

        guard downloadState == .downloading else {
            return
        }
        downloadProgressLine.strokeEnd = value
        downloadProgressLine.strokeStart = 0
        downloadingLine.strokeStart = value
        let animationDuration = 1.0
        let animationStart = prevValue == 0 ? 0 : downloadProgressLine.presentation()!.strokeEnd
        let downloadingLineAnimation = getAnimation(
            path: .strokeStart,
            from: animationStart,
            to: value,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .linear))

        let downloadingAnimation = getAnimation(
            path: .strokeEnd,
            from: animationStart,
            to: value, duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .linear))

        prevValue = value
        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        CATransaction.setCompletionBlock { [weak self] in
            if value >= 1 {
                self?.prevValue = 0
                self?.animateDownloadingEnd(animated: animated, downloaded: downloaded)
            } else {
                self?.prevValue = value
            }
        }
        downloadingLine.removeAllAnimations()
        downloadProgressLine.removeAllAnimations()

        if animated {
            downloadProgressLine.add(downloadingAnimation, forKey: AnimationSettings.Key.downloadindAnimation.rawValue)
            downloadingLine.add(downloadingLineAnimation, forKey: AnimationSettings.Key.downloadindAnimation.rawValue)
        }

        CATransaction.commit()
    }

    /// STEP 5:  Animate Download Finish and Change Button back to normal state
    func animateDownloadingEnd(force: Bool = false, cancel: Bool = false, animated: Bool = true, downloaded: (() -> Void)? = nil) {

        if !force {
            guard downloadState == .downloading else {
                return
            }
        }

        animationState = .none

        let strokeEndBorderAnimation = getAnimation(
            path: .strokeEnd,
            from: multiplier, to: 1,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .easeIn))

        let strokeEndAnimation = getAnimation(
            path: .strokeStart,
            from: 0,
            to: 1,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .easeOut))

        let lineColorAnimation = getAnimation(
            path: .strokeColor,
            from: cancel ? progressBackgroundColor.cgColor : downloadProgressColor.cgColor,
            to: progressBackgroundColor.cgColor,
            duration: animationDuration,
            timingFunction: CAMediaTimingFunction(name: .easeOut))

        CATransaction.begin()
        CATransaction.setDisableActions(!animated)
        CATransaction.setCompletionBlock { [weak self] in
            self?.conentStackView.setHidden(false)
            self?.setBackgroundHidden = false
            self?.downloadState = .none
            self?.buttonBorder.strokeStart = .zero
            self?.buttonBorder.removeFromSuperlayer()

            downloaded?()
        }

        buttonBorder.removeAllAnimations()
        downloadingLine.removeAllAnimations()

        if animated {
            buttonBorder.add(strokeEndBorderAnimation, forKey: AnimationSettings.Key.borderStrokeEnd.rawValue)
            downloadProgressLine.add(strokeEndAnimation, forKey: AnimationSettings.Key.downloadingLineStrokeEnd.rawValue)
            downloadProgressLine.add(lineColorAnimation, forKey: AnimationSettings.Key.backgroundColorChange.rawValue)
        }

        CATransaction.commit()
    }

    func getAnimation(path key: AnimationSettings.KeyPath, from fromValue: Any, to toValue: Any, duration: Double, timingFunction: CAMediaTimingFunction) -> CABasicAnimation {
        let basicAnimation = CABasicAnimation(keyPath: key.rawValue)
        basicAnimation.fromValue = fromValue
        basicAnimation.toValue = toValue
        basicAnimation.timingFunction = timingFunction
        basicAnimation.fillMode = .forwards
        basicAnimation.duration = duration
        return basicAnimation
    }
}
