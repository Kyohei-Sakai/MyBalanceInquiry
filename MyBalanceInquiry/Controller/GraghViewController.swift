//
//  GraghViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class GraghViewController: UIViewController {
    
    @IBOutlet fileprivate weak var graghScrollView: UIScrollView!
    @IBOutlet fileprivate weak var textField: UITextField!
    
    var superBank: BankManager?
    
    fileprivate var barGragh: BarGragh?
    
    fileprivate var myData: [Int] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        drawGraghIntoScrollView()
        
    }
    
    fileprivate func drawGraghIntoScrollView() {
        

        let calendar = Calendar(identifier: .gregorian)
        
        if let oldDate = superBank?.mostOldDate, let newDate = superBank?.mostNewDate {
            // 年と月だけのコンポーネントを作る
            let oldComps = DateComponents(calendar: calendar, year: calendar.component(.year, from: oldDate), month: calendar.component(.month, from: oldDate))
            
            let newComps = DateComponents(calendar: calendar, year: calendar.component(.year, from: newDate), month: calendar.component(.month, from: newDate))
            
            // Dateに戻すことでその月の1日(ついたち)が返る
            if var date = calendar.date(from: oldComps), let finalDate = calendar.date(from: newComps) {
                
                while date <= finalDate {
                    // dateの１ヶ月後
                    if let nextDate = calendar.date(byAdding: DateComponents(month: 1), to: date) {
                        // 月々の合計変動額の差
                        let totalBalance = superBank?.getSumTotalBalance(fromDate: date, toDate: nextDate) ?? 0
                        // 月々の収入
                        let income = superBank?.getTotalIncome(fromDate: date, toDate: nextDate) ?? 0
                        
                        myData.append(income - totalBalance)
                        
                        date = nextDate
                    }
                }
            }
            
        }
        
        let screenSize = UIScreen.main.bounds.size
        let height = graghScrollView.frame.size.height
        
        if let mostOldDate = superBank?.mostOldDate, let text = textField.text {
            let spendingGragh = BarGragh(dataArray: myData, oldDate: mostOldDate, barAreaWidth: screenSize.width / 4, height: height, average: Int(text) ?? 0)
            
            barGragh = spendingGragh
            
            graghScrollView.addSubview(spendingGragh)
            graghScrollView.contentSize = CGSize(width: spendingGragh.frame.size.width, height: spendingGragh.frame.size.height)
        }
        
        textField.delegate = self
        graghScrollView.delegate = self
        
    }
    
    
}


extension GraghViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        print("textFieldShouldReturn")
        // 初期化
        graghScrollView.subviews.forEach { $0.removeFromSuperview() }
        myData.removeAll()
        // 再描画
        drawGraghIntoScrollView()
        return true
    }
    
}


extension GraghViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 設定額のラベルをスクロールとともに追従させる
        barGragh?.averageLabel.frame.origin.x = scrollView.contentOffset.x
        
    }
    
}




