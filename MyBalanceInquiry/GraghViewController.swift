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
    @IBOutlet weak var textField: UITextField!
    
    var superBank: BankManager!
    
    var barGragh: BarGragh!
    
    var myData: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawGraghIntoScrollView()
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func drawGraghIntoScrollView() {
        
        let calendar = Calendar(identifier: .gregorian)
        
        let oldDate = superBank.mostOldDate
        let newDate = superBank.mostNewDate
        
        // 年と月だけのコンポーネントを作り
        let oldComps = DateComponents(calendar: calendar, year: calendar.component(.year, from: oldDate), month: calendar.component(.month, from: oldDate))
        
        let newComps = DateComponents(calendar: calendar, year: calendar.component(.year, from: newDate), month: calendar.component(.month, from: newDate))
        
        // Dateに戻すことでその月の1日(ついたち)が返る
        var date: Date = calendar.date(from: oldComps)!
        let finalDate: Date = calendar.date(from: newComps)!
        
        while date <= finalDate {
            
            let nextDate = calendar.date(byAdding: DateComponents(month: 1), to: date)
            // 収支金額
            let totalBalance = superBank.getSumTotalBalance(fromDate: date, toDate: nextDate)
            // 月々の収入
            let income = superBank.getTotalIncome(fromDate: date, toDate: nextDate)
            
            myData.append(income - totalBalance)
            
            date = nextDate!
        }
        
        let screenSize = UIScreen.main.bounds.size
        let height = graghScrollView.frame.size.height
        
        let spendingGragh = BarGragh(dataArray: myData, oldDate: superBank.mostOldDate, barAreaWidth: screenSize.width / 4, height: height, average: Int(textField.text!)!)
        self.barGragh = spendingGragh
        
        graghScrollView.addSubview(spendingGragh)
        graghScrollView.contentSize = CGSize(width: spendingGragh.frame.size.width, height: spendingGragh.frame.size.height)
        
        textField.delegate = self
        graghScrollView.delegate = self
        
    }
    
    
}


extension GraghViewController: UITextFieldDelegate {
    
//    func textFieldDidEndEditing(_ textField: UITextField) {
//        print("textFieldDidEndEditing")
//        drawGraghIntoScrollView()
//    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        // 初期化
        for sub in graghScrollView.subviews {
            sub.removeFromSuperview()
        }
        self.myData.removeAll()
        // 再描画
        drawGraghIntoScrollView()
        return true
    }
    
}


extension GraghViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 設定額のラベルをスクロールとともに追従させる
        barGragh.averageLabel.frame.origin.x = scrollView.contentOffset.x
        
    }
    
}




