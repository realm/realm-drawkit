//
//  UIImage+Palette.swift
//  RealmDrawKit
//
//  Created by Tim Oliver on 7/12/17.
//  Copyright © 2017 Realm. All rights reserved.
//

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
