//
//  ProgressTitleStackView.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 10/21/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import UIKit

public final class ProgressTitleStackView: UIStackView {

    private let animationSettings: AnimationSettings

    init(animationSettings: AnimationSettings, arrangedSubviews: [UIView]) {
        self.animationSettings = animationSettings
        super.init(frame: .zero)
        configure()

        arrangedSubviews.forEach { (subview) in
            addArrangedSubview(subview)
        }
    }

    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func configure() {
       isUserInteractionEnabled = false
       translatesAutoresizingMaskIntoConstraints = false
       alignment = .center
       spacing = 4
    }

    var setHidden: Bool = false {
        didSet {

            if alpha == .zero {
                isHidden = setHidden
            }

            UIView.transition(
                with: self,
                duration: animationSettings.duration,
                options: .curveEaseOut,
                animations: { [weak self] in
                    guard let self = self else { return }
                    self.alpha = self.setHidden ? .zero : 1

                }, completion: { [weak self] _ in
                    guard let self = self else { return }
                    self.isHidden = self.setHidden
                })
        }
    }
}
