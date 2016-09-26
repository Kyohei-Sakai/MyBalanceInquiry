//
//  GraghViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class GraghViewController: UIViewController {
    
    @IBOutlet weak var graghScrollView: UIScrollView!
    
    var superBank: BankManager!
    
    var myData: [Int] = [80000, 87000, 105000, 72000, 50000, 123973, 33023, 23244, 97564, 122333]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        let screenSize = UIScreen.main.bounds.size
        let height = graghScrollView.frame.size.height
        
        let spendingGragh = BarGragh(dataArray: myData, barAreaWidth: screenSize.width / 6, height: height)

        graghScrollView.addSubview(spendingGragh)
        graghScrollView.contentSize = CGSize(width: spendingGragh.frame.size.width, height: spendingGragh.frame.size.height)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}
