//
//  DrawStrokeView.swift
//  RealmDrawKit
//
//  Created by Tim Oliver on 7/12/17.
//  Copyright © 2017 Realm. All rights reserved.
//

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
