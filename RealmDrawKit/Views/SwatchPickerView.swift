//
//  SwatchPickerView.swift
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

class SwatchPickerView: UIView {

    /** An array of colors that can be selected in this view */
    public var colors: [UIColor]? {
        didSet { configureSwatchViews() }
    }

    /** The template images used for the swatches */
    static let swatchSize = CGSize(width: 22, height: 22)
    private let defaultSwatchImage = UIImage.defaultSwatchImage(size: SwatchPickerView.swatchSize)
    private let highlightedSwatchImage = UIImage.highlightedSwatchImage(size: SwatchPickerView.swatchSize)

    /** Views */
    public let scrollView = UIScrollView(frame: CGRect.zero)
    public var swatchViews: [UIImageView]? = nil

    private func resetSwatchViews() {
        guard swatchViews != nil else { return }

        for view in swatchViews! {
            view.removeFromSuperview()
        }
        swatchViews = nil
    }

    private func configureSwatchViews() {
        
    }
}
