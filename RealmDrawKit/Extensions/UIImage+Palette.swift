//
//  UIImage+Palette.swift
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

import Foundation
import UIKit

extension UIImage {

    class func paletteBackgroundImage(cornerRadius: CGFloat) -> UIImage {
        let width = (cornerRadius * 2.0) + 2
        let size = CGSize(width: width, height: width)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let path = UIBezierPath(roundedRect: CGRect(origin: CGPoint.zero, size: size), cornerRadius: cornerRadius)
        UIColor.black.setFill()
        path.fill()

        var image = UIGraphicsGetImageFromCurrentImageContext()!

        UIGraphicsEndImageContext()

        image = image.withRenderingMode(.alwaysTemplate)
        image = image.resizableImage(withCapInsets: UIEdgeInsets(top: cornerRadius, left: cornerRadius, bottom: cornerRadius, right: cornerRadius))

        return image
    }

    class func defaultSwatchImage(size: CGSize) -> UIImage {
        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        let circlePath = UIBezierPath(ovalIn: CGRect(origin: CGPoint.zero, size: size))
        UIColor.black.setFill()
        circlePath.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image.withRenderingMode(.alwaysTemplate)
    }

    class func highlightedSwatchImage(size: CGSize) -> UIImage {
        let frame = CGRect(origin: CGPoint.zero, size: size)

        UIGraphicsBeginImageContextWithOptions(size, false, 0.0)

        //// General Declarations
        // This non-generic function dramatically improves compilation times of complex expressions.
        func fastFloor(_ x: CGFloat) -> CGFloat { return floor(x) }


        //// Subframes
        let group: CGRect = CGRect(x: frame.minX + 1, y: frame.minY + 1, width: frame.width - 2, height: frame.height - 2)


        //// Group
        //// Outline Drawing
        let outlinePath = UIBezierPath(ovalIn: CGRect(x: group.minX + fastFloor(group.width * 0.00000 + 0.5), y: group.minY + fastFloor(group.height * 0.00000 + 0.5), width: fastFloor(group.width * 1.00000 + 0.5) - fastFloor(group.width * 0.00000 + 0.5), height: fastFloor(group.height * 1.00000 + 0.5) - fastFloor(group.height * 0.00000 + 0.5)))
        UIColor.black.setStroke()
        outlinePath.lineWidth = 2
        outlinePath.stroke()


        //// Center Drawing
        let centerPath = UIBezierPath(ovalIn: CGRect(x: group.minX + fastFloor(group.width * 0.10000 + 0.5), y: group.minY + fastFloor(group.height * 0.10000 + 0.5), width: fastFloor(group.width * 0.90000 + 0.5) - fastFloor(group.width * 0.10000 + 0.5), height: fastFloor(group.height * 0.90000 + 0.5) - fastFloor(group.height * 0.10000 + 0.5)))
        UIColor.black.setFill()
        centerPath.fill()

        let image = UIGraphicsGetImageFromCurrentImageContext()!
        UIGraphicsEndImageContext()

        return image.withRenderingMode(.alwaysTemplate)
    }
}
