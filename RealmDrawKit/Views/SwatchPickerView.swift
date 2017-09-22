//
//  SwatchPickerView.swift
//  RealmDrawKit
//
//  Created by Tim Oliver on 7/12/17.
//  Copyright © 2017 Realm. All rights reserved.
//

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
