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
    
    convenience init(target viewController: Any?, action selecter: Selector?) {
        self.init()
        self.sizeToFit()
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: viewController, action: selecter)
        let spacer     = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        self.setItems([spacer, doneButton], animated: true)
        
    }
    
    required init?(coder aDecoder: NSCoder) {
//        fatalError("init(coder:) has not been implemented")
        super.init(coder: aDecoder)
    }
    
}
