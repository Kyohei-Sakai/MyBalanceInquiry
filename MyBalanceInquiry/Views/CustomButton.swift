//
//  CustomButton.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/12/16.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit
@IBDesignable
class CustomButton: UIButton {
    
    @IBInspectable var cornerRadius: CGFloat = 0 {
        didSet {
            layer.cornerRadius = cornerRadius
        }
    }
    
    @IBInspectable var borderWidth: CGFloat = 0 {
        didSet {
            layer.borderWidth = borderWidth
        }
    }
    
    @IBInspectable var borderColor: UIColor = UIColor.clear {
        didSet {
            layer.borderColor = borderColor.cgColor
        }
    }

}
