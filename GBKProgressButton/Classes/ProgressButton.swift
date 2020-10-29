//
//  ProgressButton.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 10/21/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import UIKit

@IBDesignable public class GBKProgressButton: UIControl {

    private enum Side {
        case left
        case right
    }

    private enum DownloadState {
        case none
        case pending
        case downloading
    }

    // MARK: - Public API

    @IBInspectable public var lineWidth: CGFloat = 2
    @IBInspectable public var primaryColor: UIColor = UIColor(white: 0.9, alpha: 1)
    @IBInspectable public var progressBackgroundColor: UIColor = UIColor(white: 0.9, alpha: 1)
    @IBInspectable public var downloadProgressColor: UIColor = UIColor(red: 0.49, green: 0.74, blue: 0.88, alpha: 1.00)

    @IBInspectable public lazy var animationDuration: Double = animationSettings.duration {
        didSet {
            animationSettings.duration = animationDuration
        }
    }

    @IBInspectable public var titleText: String = String() {
        didSet {
            titleLabel.text = titleText
        }
    }

    @IBInspectable public var titleColor: UIColor = .black {
        didSet {
            titleLabel.textColor = titleColor
        }
    }

    @IBInspectable public var titleImage: UIImage? {
        didSet {
            imageView.image = titleImage
        }
    }

    @IBInspectable public lazy var buttonCorners: CGFloat = circleRadius

    @IBInspectable public var gradientTopColor: UIColor?
    @IBInspectable public var gradientBottomColor: UIColor?
    @IBInspectable public var gradientOpacity: CGFloat = 1
    @IBInspectable public var gradientStartPoint: CGPoint = CGPoint(x: 0, y: 0.5)
    @IBInspectable public var gradientEndPoint: CGPoint = CGPoint(x: 1, y: 0.5)

    public lazy var font: UIFont = UIFont.systemFont(ofSize: 13) {
        didSet {
            titleLabel.font = font
        }
    }

    public var attributedText: NSAttributedString? {
        didSet {
            titleLabel.attributedText = attributedText
        }
    }

    public private(set) lazy var imageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFit
        imageView.image = titleImage
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.isUserInteractionEnabled = false
        return imageView
    }()

    public private(set) lazy var titleLabel: UILabel = {
        let label = UILabel()
        label.textAlignment = .center
        label.font = font
        label.textColor = .black
        return label
    }()

    public var currentProgress: CGFloat {
        prevValue
    }

    // MARK: - END of Public API

    public override class var layerClass: AnyClass {
        CAGradientLayer.self
    }

    private lazy var conentStackView: ProgressTitleStackView = {
        let stack = ProgressTitleStackView(animationSettings: animationSettings, arrangedSubviews: [imageView, titleLabel])
        return stack
    }()

    private let animationSettings = AnimationSettings()
    private var prevValue: CGFloat = 0
    private var animationDelayWorkItem: DispatchWorkItem?

    private var setBackgroundHidden: Bool = false {
        didSet {
            UIView.transition(
                with: self,
                duration: animationDuration,
                options: .curveEaseOut,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.backgroundColor = self.setBackgroundHidden ? .clear : self.primaryColor

                }, completion: nil)
        }
    }

    private var animationState: AnimationSettings.State = .none {
        willSet(newValue) {
            animationStateWillChange(to: newValue)
        }
        didSet {
            if animationState != .none {
                configureGradient()
            }
        }
    }

    private var downloadState: DownloadState = .none {
        didSet {
            isUserInteractionEnabled = downloadState == .none
            configureGradient()
        }
    }

    private lazy var downloadingLine: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.bounds = bounds
        layer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressBackgroundColor.cgColor
        layer.lineWidth = lineWidth
        layer.path = circlePath.cgPath
        layer.strokeStart = 0
        layer.strokeEnd = 0
        return layer
    }()

    private lazy var downloadProgressLine: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.bounds = bounds
        layer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = downloadProgressColor.cgColor
        layer.lineWidth = lineWidth
        layer.path = circlePath.cgPath
        layer.strokeStart = 0
        layer.strokeEnd = 0
        return layer
    }()

    private lazy var buttonBorder: CAShapeLayer = {
        let layer = CAShapeLayer()
        layer.bounds = bounds
        layer.position = CGPoint(x: bounds.width / 2.0, y: bounds.height / 2.0)
        layer.fillColor = UIColor.clear.cgColor
        layer.strokeColor = progressBackgroundColor.cgColor// color().cgColor
        layer.lineWidth = lineWidth
        layer.path = borderPath.cgPath
        return layer
    }()

    private var multiplier: CGFloat {
        let perimeterRounded = 2 * (bounds.width + bounds.height - buttonCorners * (4 - .pi))
        let perimeterFull = 2 * (bounds.width + bounds.height)
        let topPathLength = perimeterRounded - (perimeterFull - perimeterRounded) - (bounds.height * 2) - bounds.width + (buttonCorners/4)
        let topPathHalf = topPathLength/2
        let topPathHalfPercenrage = topPathHalf/perimeterRounded
        return topPathHalfPercenrage
    }

    private func animationStateWillChange(to newValue: AnimationSettings.State) {
        switch newValue {
        case .borderToCircle:
            buttonBorder.path = borderPath.cgPath
            buttonBorder.strokeStart = multiplier
            buttonBorder.strokeEnd = .zero
            buttonBorder.lineCap = .round
            buttonBorder.strokeColor = progressBackgroundColor.cgColor//color().cgColor
            downloadingLine.strokeStart = 0.15
            downloadingLine.strokeEnd = 1
            downloadingLine.strokeColor = progressBackgroundColor.cgColor//color().cgColor
        case .rotateToEnd:
            downloadProgressLine.strokeStart = .zero
            downloadProgressLine.strokeEnd = .zero
            downloadProgressLine.lineCap = .round
            downloadingLine.strokeStart = .zero
            downloadingLine.strokeEnd = 1
            downloadingLine.lineCap = .round
        case .downloading:
            downloadProgressLine.strokeColor = downloadProgressColor.cgColor
        case .none:
            buttonBorder.path = borderPath.cgPath
            buttonBorder.strokeStart = multiplier
            buttonBorder.strokeEnd = 1
            downloadingLine.strokeStart = .zero
            downloadingLine.strokeEnd = .zero
            downloadProgressLine.strokeStart = 1
            downloadProgressLine.strokeEnd = 1
        case .circleRotation:
            downloadingLine.lineCap = .round
        }
    }

    public init() {
        super.init(frame: .zero)
        commonInit()
    }

    public required init?(coder: NSCoder) {
        super.init(coder: coder)
        commonInit()
    }

    private func commonInit() {
        addSubview(conentStackView)
        conentStackView.centerYAnchor.constraint(equalTo: centerYAnchor).isActive = true
        conentStackView.centerXAnchor.constraint(equalTo: centerXAnchor).isActive = true
        conentStackView.leftAnchor.constraint(greaterThanOrEqualTo: leftAnchor,constant: 4).isActive = true
        conentStackView.rightAnchor.constraint(lessThanOrEqualTo: rightAnchor, constant: -4).isActive = true
        conentStackView.bottomAnchor.constraint(lessThanOrEqualTo: bottomAnchor, constant: -4).isActive = true
        conentStackView.topAnchor.constraint(greaterThanOrEqualTo: topAnchor, constant: 4).isActive = true
        imageView.widthAnchor.constraint(equalTo: imageView.heightAnchor).isActive = true
        isUserInteractionEnabled = true
        configureLabel()
    }

    override public func layoutSubviews() {
        super.layoutSubviews()
        layer.cornerRadius = buttonCorners
        configureInspectables()
        configureGradient()
    }
}

// MARK: - Inner logic

private extension GBKProgressButton {

    func configureLabel() {
        titleLabel.font = font
        titleLabel.textColor = titleColor
    }

    func configureLayer() {

        layer.cornerRadius = buttonCorners

        if buttonBorder.superlayer == nil {
            layer.addSublayer(buttonBorder)
        }

        if downloadingLine.superlayer == nil {
            layer.addSublayer(downloadingLine)
        }

        if downloadProgressLine.superlayer == nil {
            layer.addSublayer(downloadProgressLine)
        }
    }

    func configureInspectables() {
        let color = setBackgroundHidden ? .clear : primaryColor

        if backgroundColor != color {
            backgroundColor = color
        }

        if titleLabel.text != titleText {
            titleLabel.text = titleText
        }

        if titleLabel.textColor != titleColor {
            titleLabel.textColor = titleColor
        }

        if imageView.image != titleImage {
            imageView.image = titleImage
        }

        if titleLabel.font != font {
            titleLabel.font = font
        }

        if attributedText != nil, titleLabel.attributedText != attributedText {
            titleLabel.attributedText = attributedText
            titleLabel.isHidden = attributedText!.string.isEmpty
        } else if titleLabel.text != titleText {
            titleLabel.text = titleText
            titleLabel.isHidden = titleText.isEmpty
        } else {
            titleLabel.isHidden = titleText.isEmpty
        }

        imageView.isHidden = titleImage == nil
    }
}

// MARK: - Public API

public extension GBKProgressButton {

    /// To reset button in UITableViewCell/UICollectionViewCell
    func prepareForReuse() {
        UIView.performWithoutAnimation {
            CATransaction.begin()
            CATransaction.setDisableActions(true)

            animationDelayWorkItem?.cancel()
            prevValue = 0
            downloadState = .none
            animationState = .none
            conentStackView.setHidden = false
            setBackgroundHidden = false
            configureGradient()

            buttonBorder.removeAllAnimations()
            downloadingLine.removeAllAnimations()
            downloadProgressLine.removeAllAnimations()
            buttonBorder.removeFromSuperlayer()
            downloadingLine.removeFromSuperlayer()
            downloadProgressLine.removeFromSuperlayer()
            CATransaction.commit()
        }
    }
    
    func reset() {
        guard animationState != .none || downloadState != .none else {
            return
        }
        prevValue = 0
        animationState = .none
        downloadState = .none
        animateDownloadingEnd(force: true, cancel: true)
        layer.removeAllAnimations()
    }
    
    func animate(to newValue: CGFloat = 0.0, animated: Bool = true, downloaded: (() -> Void)? = nil) {

        configureLayer()

        if newValue > 0.0 {
            if animationState == .none {
                CATransaction.begin()
                CATransaction.setDisableActions(!animated)
                CATransaction.setCompletionBlock { [weak self] in
                    CATransaction.begin()
                    CATransaction.setDisableActions(!animated)
                    CATransaction.setCompletionBlock { [weak self] in
                        self?.animateDownloading(value: max(0, min(1, newValue)), animated: animated, downloaded: downloaded)
                    }
                    self?.startDownloading(animated: animated)
                    CATransaction.commit()
                }

                startSpinning(animated: animated)
                CATransaction.commit()
            } else if animationState == .borderToCircle || animationState == .rotateToEnd {
                animationDelayWorkItem?.cancel()

                let task = DispatchWorkItem { [weak self] in
                    self?.animate(to: newValue, animated: animated, downloaded: downloaded)
                }

                self.animationDelayWorkItem = task
                DispatchQueue.main.asyncAfter(deadline: .now() + animationDuration, execute: task)
            } else if animationState == .circleRotation {
                CATransaction.begin()
                CATransaction.setDisableActions(!animated)
                CATransaction.setCompletionBlock { [weak self] in
                    self?.animateDownloading(value: max(0, min(1, newValue)), animated: animated, downloaded: downloaded)
                }
                startDownloading(animated: animated)
                CATransaction.commit()
            } else if animationState == .downloading {
                animateDownloading(value: max(0, min(1, newValue)), animated: animated, downloaded: downloaded)
            }
        } else {
            CATransaction.begin()
            CATransaction.setDisableActions(!animated)
            startSpinning(animated: animated)
            CATransaction.commit()
        }
    }

    private func startSpinning(animated: Bool = true) {
        guard downloadState == .none else {
            return
        }

        animateBorderToCircle(animated: animated)
        conentStackView.setHidden = true
        setBackgroundHidden = true
    }

    private func startDownloading(animated: Bool = true) {
        guard animationState == .circleRotation else {
            return
        }

        animateRotateToEnd(animated: animated)
    }
}

// MARK: - Gradient

private extension GBKProgressButton {

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

// MARK: - Paths

private extension GBKProgressButton {

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

private extension GBKProgressButton {

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

// MARK: - Animations

private extension GBKProgressButton {

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
            self?.conentStackView.setHidden = false
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
