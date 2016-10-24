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
        configure()
        
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
                        // 月々の総増減額
                        let fluctuationAmount = superBank?.sumFluctuationAmount(fromDate: date, toDate: nextDate) ?? 0
                        // 月々の収入
                        let income = superBank?.totalIncome(fromDate: date, toDate: nextDate) ?? 0
                        myData.append(income - fluctuationAmount)
                        
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
        
    }
    
    fileprivate func configure() {
        textField.placeholder = "100000"
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        // ツールバーを生成
        let accessoryBar = UIToolbar()
        accessoryBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneButtonDidPush(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryBar.setItems([spacer, doneButton], animated: true)
        
        // ツールバーをtextViewのアクセサリViewに設定する
        textField.inputAccessoryView = accessoryBar
        
        graghScrollView.delegate = self
    }
    
    @objc private func doneButtonDidPush(_ sender: UIButton) {
        // 初期化
        graghScrollView.subviews.forEach { $0.removeFromSuperview() }
        myData.removeAll()
        // 再描画
        drawGraghIntoScrollView()
        // キーボードを閉じる
        textField.resignFirstResponder()
        // 画面位置を元に戻す
        self.view.frame.origin.y = 0
    }
    
}


// MARK: - UITextFieldDelegate method

extension GraghViewController: UITextFieldDelegate {
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        // 画面を上にずらしてTextFieldが見えるようにする
        self.view.frame.origin.y = -200
        return true
    }
    
}


// MARK: - UIScrollViewDelegate method

extension GraghViewController: UIScrollViewDelegate {
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        // 設定額のラベルをスクロールとともに追従させる
        barGragh?.averageLabel.frame.origin.x = scrollView.contentOffset.x
        
    }
    
}




