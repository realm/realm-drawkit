//
//  DrawStrokeView.swift
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

open class DrawStrokeThicknessView: UIView {

    // Set this view to be backed by CAShapeLayer
    private var shapeLayer: CAShapeLayer {
        return self.layer as! CAShapeLayer
    }

    // Thickness of the the stroke
    public var strokeThickness = 2.0 {
        didSet {
            shapeLayer.lineWidth = CGFloat(strokeThickness)
        }
    }

    // Color of the stroke
    public var strokeColor = UIColor.black {
        didSet {
            shapeLayer.strokeColor = strokeColor.cgColor
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        shapeLayer.lineCap = kCALineCapRound;
        shapeLayer.lineWidth = CGFloat(strokeThickness)
        shapeLayer.strokeColor = strokeColor.cgColor
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override open class var layerClass: AnyClass {
        get {
            return CAShapeLayer.self
        }
    }

    override open func layoutSubviews() {
        super.layoutSubviews()

        var linePoint = CGPoint(x: CGFloat(strokeThickness*0.5), y: self.frame.size.height * 0.5)

        // Update the location of the draw stroke in this view
        let path = UIBezierPath()
        path.move(to: linePoint)

        linePoint.x = self.frame.size.width - CGFloat(strokeThickness*0.5)
        path.addLine(to: linePoint)

        shapeLayer.path = path.cgPath
    }
}
