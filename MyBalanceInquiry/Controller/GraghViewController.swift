//
//  GraghViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class GraghViewController: UIViewController {
    
    @IBOutlet fileprivate weak var textField: UITextField!
    @IBOutlet fileprivate weak var graghView: GraghView!
    
    var superBank: BankManager?
    
    fileprivate var barGraghData: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "支出管理"
        
        setBarGraghData()
        configureBarGragh()
        configureTextField()
        
    }
    
    fileprivate func setBarGraghData() {
        let calendar = Calendar(identifier: .gregorian)
        
        if let minimumDate = superBank?.mostOldDate, let newDate = superBank?.mostNewDate {
            // 年と月だけのコンポーネントを作る
            let oldComps = DateComponents(calendar: calendar, year: calendar.component(.year, from: minimumDate), month: calendar.component(.month, from: minimumDate))
            
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
                        barGraghData.append(CGFloat(income - fluctuationAmount))
                        
                        date = nextDate
                    }
                }
            }
        }
    }
    
    fileprivate func configureBarGragh() {
//        let graghView = GraghView(frame: CGRect(x: 0, y: 97, width: UIScreen.main.bounds.size.width, height: 340))
        // グラフデータをセット
        graghView.graghValues = barGraghData
        // ラベルデータをセット
        if let mostOldDate = superBank?.mostOldDate {
            graghView.minimumDate = mostOldDate
        }
        // グラフレイアウトデータをセット
        graghView.graghStyle = .round
        graghView.setBarWidth(rate: 0.9)
        graghView.setBarAreaHeight(rate: 0.9)
        graghView.setMaxGraghValue(rate: 0.6)
        graghView.setBarArea(width: 100)
        graghView.setComparisonValueLine(color: .green)
        graghView.setComparisonValueLabel(backgroundColor: UIColor.yellow.withAlphaComponent(0.7))
        // グラフを生成
        graghView.loadGraghView()
        
        graghView.delegate = self
        
        view.addSubview(graghView)
    }
    
    fileprivate func configureTextField() {
        textField.placeholder = "100000"
        textField.textAlignment = .right
        textField.keyboardType = .numberPad
        textField.clearButtonMode = .whileEditing
        textField.delegate = self
        
        // ツールバーを生成
        let accessoryBar = UIToolbar()
        accessoryBar.sizeToFit()
        
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: self, action: #selector(doneButtonDidPush(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryBar.setItems([spacer, doneButton], animated: true)
        
        // ツールバーをtextViewのアクセサリViewに設定する
        textField.inputAccessoryView = accessoryBar
    }
    
    @objc private func doneButtonDidPush(_ sender: UIButton) {
        if let text = textField.text {
           graghView.comparisonValue = CGFloat(Int(text) ?? 0)
        }
        // 再描画
        graghView.reloadGraghView()
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
        view.frame.origin.y = -200
        return true
    }
    
}


// MARK: - UIScrollViewDelegate method

extension GraghViewController: UIScrollViewDelegate {
    
//    func scrollViewDidScroll(_ scrollView: UIScrollView) {
//        // 設定額のラベルをスクロールとともに追従させる
//        barGraghView?.redrawComparisonValue()
//    }
    
}




