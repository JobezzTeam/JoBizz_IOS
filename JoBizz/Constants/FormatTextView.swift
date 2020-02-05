//
//  FormatTextView.swift
//  JoBizz
//
//  Created by harold Armijo Leon on 09/12/2019.
//  Copyright © 2019 harold Armijo Leon. All rights reserved.
//

import Foundation
import UIKit

struct Formatted {
    var heading: String
    var descriptionText: String

    var bodyParagraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.lineSpacing = 10
        style.paragraphSpacingBefore = 6
        style.paragraphSpacing = 6
        return style
    }()

    var headerParagraphStyle: NSMutableParagraphStyle = {
        let style = NSMutableParagraphStyle()
        style.paragraphSpacingBefore = 24
        return style
    }()

    var bodyAttributes: [NSAttributedString.Key: Any]
    var headerAttributes: [NSAttributedString.Key: Any]
    
    init(heading: String, descriptionText: String) {
        self.heading = heading
        self.descriptionText = descriptionText
        self.headerAttributes = [
            NSAttributedString.Key.font: UIFont(name: "GothamRounded-Medium", size: 22)!,
            NSAttributedString.Key.paragraphStyle: headerParagraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
        self.bodyAttributes = [
            NSAttributedString.Key.font: UIFont(name: "GothamRounded-Light", size: 14)!,
            NSAttributedString.Key.paragraphStyle: bodyParagraphStyle,
            NSAttributedString.Key.foregroundColor: UIColor.label
        ]
    }

    func attributeString(includeLineBreak: Bool = true) -> NSAttributedString {
        let result = NSMutableAttributedString()
        result.append(NSAttributedString(string: self.heading + "\n", attributes: self.headerAttributes))
        result.append(NSAttributedString(string: self.descriptionText, attributes: self.bodyAttributes))
        if includeLineBreak {
            result.append(NSAttributedString(string: "\n", attributes: self.bodyAttributes))
        }

        return result as NSAttributedString
    }

}
