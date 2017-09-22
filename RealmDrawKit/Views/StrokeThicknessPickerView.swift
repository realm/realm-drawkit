//
//  DrawThicknessPickerView.swift
//  RealmDrawKit
//
//  Created by Tim Oliver on 7/19/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit

open class StrokeThicknessPickerView: UIView {

    // The currently selected index
    public var selectedIndex = 0 {
        didSet { self.setNeedsLayout() }
    }

    // Handler for when the user picks a new stroke size
    public var strokeChangedHandler: ((Int) -> (Void))?

    // The distance between the label and stroke view
    var itemPadding = 2.0

    // The distance between each item
    var itemSpacing = 22.0

    // An array of values denoting the stroke choices
    public private(set) var items: [String]? {
        didSet {
            resetAllViews()
            setUpViews()
        }
    }

    var selectedIconView = UIImageView(frame: CGRect(origin: CGPoint.zero, size: CGSize(width: 5, height: 5)))

    // An array of all of the stroke thickness views to display
    var strokeViews: [DrawStrokeThicknessView]?

    // An array of the labels above easck stroke view
    var labelViews: [UILabel]?

    init(items: [String]) {
        super.init(frame: CGRect.zero)
        self.items = items
        setUpViews()
    }

    required public init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func resetAllViews() {
        let subviews = self.subviews
        for view in subviews { view.removeFromSuperview() }
        self.strokeViews = nil
        self.labelViews = nil
    }

    private func setUpViews() {
        guard items != nil else { return }
        guard items!.count > 0 else { return }

        strokeViews = [DrawStrokeThicknessView]()
        labelViews = [UILabel]()

        for value in items! {
            // Create the label
            let label = createLabel()
            label.text = value
            label.sizeToFit()
            addSubview(label)
            labelViews?.append(label)

            // Create the stroke view
            let strokeView = DrawStrokeThicknessView()
            strokeView.strokeThickness = Double(value)!
            addSubview(strokeView)
            strokeViews?.append(strokeView)
        }

        selectedIconView.image = self.tintedCircleImageWithSize(size: selectedIconView.frame.size)
        self.addSubview(selectedIconView)

        sizeToFit()
    }

    open override func sizeToFit() {
        super.sizeToFit()

        var height = 0.0
        for label in labelViews! {
            height += Double(label.frame.size.height) + itemPadding
        }

        for strokeView in strokeViews! {
            height += Double(strokeView.frame.size.height)
        }

        height += itemSpacing * Double(items!.count - 1)

        frame.size.height = CGFloat(height)
    }

    open override func layoutSubviews() {
        super.layoutSubviews()

        guard items != nil else { return }

        var y = 0.0
        for i in 0..<items!.count {
            let label = labelViews![i]
            label.frame.origin.y = CGFloat(y)

            y += Double(label.frame.size.height) + itemPadding

            let strokeView = strokeViews![i]
            strokeView.frame.size.width = bounds.size.width
            strokeView.frame.size.height = CGFloat(strokeView.strokeThickness)
            strokeView.frame.origin.y = CGFloat(y)

            if i == selectedIndex {
                selectedIconView.frame.origin.x = -(selectedIconView.frame.size.width + 5);
                selectedIconView.frame.origin.y = strokeView.frame.midY - (selectedIconView.frame.size.height * 0.5)
            }

            y += itemSpacing
        }
    }

    private func itemIndex(for point: CGPoint) -> Int {
        let sectionHeight = CGFloat(self.frame.height / CGFloat(self.items!.count))
        let touchIndex = Int(floor(point.y / sectionHeight))
        return touchIndex
    }

    open override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        guard let touch = touches.first else { return }
        let touchPoint = touch.location(in: self)
        let touchIndex = self.itemIndex(for: touchPoint)
        self.selectedIndex = touchIndex

        if let labelViews = self.labelViews {
            labelViews[touchIndex].alpha = 0.4
        }

        if let strokeViews = self.strokeViews {
            strokeViews[touchIndex].alpha = 0.4
        }

        self.strokeChangedHandler?(self.selectedIndex)
    }

    open override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesEnded(touches, with: event)

        UIView.animate(withDuration: 0.4) {
            for labelView in self.labelViews! { labelView.alpha = 1.0 }
            for strokeView in self.strokeViews! { strokeView.alpha = 1.0 }
        }
    }

    private func createLabel() -> UILabel {
        let label = UILabel()
        label.textColor = .black
        label.font = UIFont.systemFont(ofSize: 11.0, weight: UIFont.Weight.bold)
        return label
    }

    private func tintedCircleImageWithSize(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        UIColor.black.setFill()
        circlePath.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image.withRenderingMode(.alwaysTemplate)
    }

}
