//
//  PaletteView.swift
//  RealmDrawKit
//
//  Created by Tim Oliver on 7/12/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit

open class DrawPaletteButton: UIControl {

    public let strokeView = DrawStrokeThicknessView()
    public let backgroundView = UIImageView()

    public var strokeIconTappedHandler: (() -> ())?

    public init() {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 60, height: 36)))

        backgroundView.image = UIImage.paletteBackgroundImage(cornerRadius: 8)
        backgroundView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        backgroundView.frame = bounds
        backgroundView.isUserInteractionEnabled = false
        backgroundView.tintColor = UIColor(white: 0.97, alpha: 1.0)
        backgroundView.layer.shadowRadius = 4.0
        backgroundView.layer.shadowOpacity = 0.12
        backgroundView.layer.shadowColor = UIColor.black.cgColor
        backgroundView.layer.shadowOffset = CGSize.zero
        backgroundView.layer.shadowPath = UIBezierPath(roundedRect: backgroundView.bounds, cornerRadius: 8).cgPath
        addSubview(backgroundView)

        strokeView.frame = bounds.insetBy(dx: 12, dy: 0)
        strokeView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        strokeView.isUserInteractionEnabled = false
        addSubview(strokeView)

        self.addTarget(self, action: #selector(didTouchDown), for: .touchDown)
        self.addTarget(self, action: #selector(didTouchUpInside), for: .touchUpInside)
        self.addTarget(self, action: #selector(didDragOutside), for: .touchDragExit)
    }

    @objc public func didTouchDown() {
        strokeView.alpha = 0.5
    }

    @objc public func didTouchUpInside() {
        UIView.animate(withDuration: 0.4) {
            self.strokeView.alpha = 1.0
        }

        strokeIconTappedHandler?()
    }

    @objc public func didDragOutside() {
        strokeView.alpha = 1.0
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
