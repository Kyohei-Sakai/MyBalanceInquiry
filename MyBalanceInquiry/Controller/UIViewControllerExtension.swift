//
//  UIViewControllerExtension.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/12/11.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit
import Foundation

extension UIViewController {
    
    func performSegue(withSegueType type: SegueType, sender: Any?) {
        performSegue(withIdentifier: type.rawValue, sender: sender)
    }
    
}


enum SegueType: String {
    //    case root = "toRoot"
    case bank = "toMyBank"
    case banking = "toBankingViewController"
    case addBank = "toAddNewBank"
    case gragh = "toGraghView"
    
}
