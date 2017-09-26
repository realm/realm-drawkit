//
//  ColorPickerView.swift
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

class ColorPickerView: UIView {

    public var selectedIndex: Int = 0 {
        didSet { self.setNeedsLayout() }
    }

    public var colorSelectedHandler: ((Int) -> (Void))?

    public private(set) var colors: [UIColor]?

    var circleSize = CGSize(width: 32, height: 32) {
        didSet { }
    }

    var imageViews: [UIImageView]?

    var circleImage: UIImage?
    var highlightedCircleImage: UIImage?

    var numberPerColumn = 5
    var numberPerRow = 4

    public init(colors: [UIColor]) {
        super.init(frame: CGRect.zero)
        self.colors = colors
        setUpCircleImages()
        setUpCircleViews()
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    private func setUpCircleViews() {
        guard colors != nil else { return }

        imageViews = [UIImageView]()

        for color in colors! {
            let imageView = UIImageView(image: circleImage)
            imageView.tintColor = color
            imageViews?.append(imageView)
            addSubview(imageView)
        }

        setNeedsLayout()
    }

    private func setUpCircleImages() {
        guard self.colors != nil else { return }

        circleImage = UIImage.defaultSwatchImage(size: circleSize)
        highlightedCircleImage = UIImage.highlightedSwatchImage(size: circleSize)

        guard imageViews != nil else { return }

        for imageView in imageViews! {
            imageView.image = circleImage
            imageView.frame.size = circleImage!.size
        }

        setNeedsLayout()
    }

    override func layoutSubviews() {

        guard imageViews != nil else { return }

        let columnSpacing = (frame.size.height - (CGFloat(numberPerColumn) * circleSize.height)) / CGFloat(numberPerColumn - 1)
        let rowSpacing = (frame.size.width - (CGFloat(numberPerRow) * circleSize.width)) / CGFloat(numberPerRow - 1)

        var x = 0.0
        var y = 0.0
        var i = 0

        for imageView in imageViews! {

            imageView.image = (i == self.selectedIndex) ? highlightedCircleImage : circleImage
            imageView.frame.origin = CGPoint(x: x, y: y)

            i += 1
            y += Double(circleSize.height + columnSpacing)

            if i % Int(numberPerColumn) == 0 {
                y = 0.0
                x += Double(circleSize.width + rowSpacing)
            }
        }
    }

    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        let touchPoint = touches.first!.location(in: self)

        let sectionWidth = CGFloat(self.frame.size.width / CGFloat(numberPerRow));
        let horizontalPosition = Int(floor(touchPoint.x / sectionWidth))

        let sectionHeight = CGFloat(self.frame.size.height / CGFloat(numberPerColumn));
        let verticalPosition = Int(floor(touchPoint.y / sectionHeight))

        selectedIndex = verticalPosition + (numberPerColumn * horizontalPosition)

        imageViews![selectedIndex].alpha = 0.4

        self.colorSelectedHandler?(selectedIndex)
    }

    override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?) {
        super.touchesBegan(touches, with: event)

        UIView.animate(withDuration: 0.4) {
            for imageView in self.imageViews! { imageView.alpha = 1.0 }
        }
    }
}
