//
//  CustomToolbar.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2017/03/28.
//  Copyright © 2017年 酒井恭平. All rights reserved.
//

import UIKit

class CustomToolbar: UIToolbar {
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(target: Any?, action: Selector?) {
        self.init()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: target, action: action)
        let spacer     = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setItems([spacer, doneButton], animated: true)
        self.sizeToFit()
        
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
}
