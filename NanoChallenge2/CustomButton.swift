//
//  CustomButton.swift
//  NanoChallenge2
//
//  Created by aurelia  natasha on 18/09/19.
//  Copyright © 2019 aurelia  natasha. All rights reserved.
//

import UIKit
@IBDesignable

class CustomButton: UIButton {

    @IBInspectable var cornerRadius: CGFloat = 0{
        didSet{
            self.layer.cornerRadius = cornerRadius
        }
    }

}
