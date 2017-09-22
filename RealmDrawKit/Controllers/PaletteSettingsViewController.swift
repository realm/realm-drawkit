//
//  PaletteSettingsViewController.swift
//  RealmDrawKit
//
//  Created by Tim Oliver on 7/18/17.
//  Copyright © 2017 Realm. All rights reserved.
//

import UIKit

class PaletteSettingsViewController: UIViewController, UIPopoverPresentationControllerDelegate, UIAdaptivePresentationControllerDelegate {

    private let thicknessLabel = UILabel()
    private let colorLabel = UILabel()
    private let separatorView = UIView()

    private let strokePickerView = StrokeThicknessPickerView(items: ["1", "2", "3", "5", "7", "10"])
    private let colorPickerView = ColorPickerView(colors: [
        // First Column
        UIColor.black,
        UIColor(white: 0.2, alpha: 1.0),
        UIColor(white: 0.4, alpha: 1.0),
        UIColor(white: 0.6, alpha: 1.0),
        UIColor(white: 0.8, alpha: 1.0),
        // Second Column
        UIColor(hexString: "167efb"),
        UIColor(hexString: "72dffd"),
        UIColor(hexString: "54d628"),
        UIColor(hexString: "fdcf31"),
        UIColor(hexString: "fb9326"),
        // Third Column
        UIColor(hexString: "fb3141"),
        UIColor(hexString: "995112"),
        UIColor(hexString: "8560f3"),
        UIColor(hexString: "1ba0b7"),
        UIColor(hexString: "159d4d"),
        // Forth Column
        UIColor(hexString: "f25192"),
        UIColor(hexString: "d34ca3"),
        UIColor(hexString: "9a50a5"),
        UIColor(hexString: "59569e"),
        UIColor(hexString: "39477f"),
])

    private let contentInset = CGSize(width: 20.0, height: 15.0)

    convenience init() {
        self.init(nibName: nil, bundle: nil)
        modalPresentationStyle = .popover
        preferredContentSize = CGSize(width: 310, height: 262)
        popoverPresentationController?.delegate = self
        presentationController?.delegate = self
    }

    override func viewDidLoad() {
        super.viewDidLoad()

        // Set up label views
        let font = UIFont.systemFont(ofSize: 12.0, weight: UIFontWeightBold)
        thicknessLabel.font = font
        colorLabel.font = font

        thicknessLabel.text = "THICKNESS"
        colorLabel.text = "COLOR"

        let labelColor = UIColor(white: 0.3, alpha: 1.0)
        thicknessLabel.textColor = labelColor
        colorLabel.textColor = labelColor

        thicknessLabel.sizeToFit()
        colorLabel.sizeToFit()

        thicknessLabel.frame.origin.x = contentInset.width
        thicknessLabel.frame.origin.y = contentInset.height
        view.addSubview(thicknessLabel)
        view.addSubview(colorLabel)

        // Set up stroke picker
        strokePickerView.frame.size.width = 67
        strokePickerView.frame.origin.y = thicknessLabel.frame.maxY + 10
        strokePickerView.frame.origin.x = contentInset.width
        view.addSubview(strokePickerView)

        // Set up separator
        separatorView.backgroundColor = UIColor(white: 0.7, alpha: 1.0)
        separatorView.frame.origin.x = strokePickerView.frame.maxX + contentInset.width
        separatorView.frame.origin.y = contentInset.height
        separatorView.frame.size.width = 1.0
        separatorView.frame.size.height = view.frame.size.height - (contentInset.height * 2)
        separatorView.autoresizingMask = [.flexibleHeight]
        view.addSubview(separatorView)

        colorLabel.frame.origin.x = separatorView.frame.maxX + contentInset.width
        colorLabel.frame.origin.y = contentInset.height

        // Set up color picker
        colorPickerView.frame.origin.x = separatorView.frame.maxX + contentInset.width
        colorPickerView.frame.origin.y = colorLabel.frame.maxY + 10
        colorPickerView.frame.size.width = (view.frame.size.width - colorPickerView.frame.minX) - contentInset.width
        colorPickerView.frame.size.height = (view.frame.size.height - colorPickerView.frame.minY) - contentInset.width
        colorPickerView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        view.addSubview(colorPickerView)
    }

    func adaptivePresentationStyle(for controller: UIPresentationController) -> UIModalPresentationStyle {
        return .none
    }

}
