//
//  PaletteView.swift
//
//  Copyright 2017 Realm Inc. All rights reserved.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to
//  deal in the Software without restriction, including without limitation the
//  rights to use, copy, modify, merge, publish, distribute, sublicense, and/or
//  sell copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
//  OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY,
//  WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR
//  IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

import UIKit

open class DrawPaletteButton: UIControl {

    public let strokeView = DrawStrokeThicknessView()
    public let backgroundView = UIImageView()

    public var strokeIconTappedHandler: (() -> ())?

    public init() {
        super.init(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 40, height: 40)))

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
