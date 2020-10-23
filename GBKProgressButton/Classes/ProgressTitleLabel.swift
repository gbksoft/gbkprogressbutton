//
//  ProgressTitleLabel.swift
//  GBKProgressButton
//
//  Created by Roman Mizin on 10/21/20.
//  Copyright © 2020 Roman Mizin. All rights reserved.
//

import UIKit

final class ProgressTitleLabel: UILabel {

    private let animationSettings: AnimationSettings

    init(animationSettings: AnimationSettings) {
        self.animationSettings = animationSettings
        super.init(frame: .zero)
        configure()
    }

    required init?(coder: NSCoder) {
        fatalError()
    }

    private func configure() {
        textAlignment = .center
        textColor = .black
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
