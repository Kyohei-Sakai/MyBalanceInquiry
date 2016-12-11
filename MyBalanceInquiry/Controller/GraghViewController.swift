//
//  GraghViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit
import PlugAndChugChart

class GraghViewController: UIViewController {
    
    @IBOutlet fileprivate weak var textField: UITextField!
    
    let graph = PlugAndChugChart()
    
    var superBank: BankManager?
    
    fileprivate var graphData: [CGFloat] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "支出管理"
        
        setGraphData()
        configureGraph()
        configureTextField()
        
    }
    
    fileprivate func setGraphData() {
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
                        graphData.append(CGFloat(income - fluctuationAmount))
                        
                        date = nextDate
                    }
                }
            }
        }
    }
    
    fileprivate func configureGraph() {
        // most setting
        graph.frame = CGRect(x: 0, y: 70, width: view.frame.width, height: 440)
        graph.chartValues = graphData
        graph.dataLabelType = .date
        if let mostOldDate = superBank?.mostOldDate {
            graph.minimumDate = mostOldDate
        }
        
        // optional setting
//        graph.style = .jaggy   // default is bar
//        graph.dateStyle = .day    // default is month
        graph.dataType = .yen
        graph.contentOffsetControll = .maximizeDate
        
        graph.setBarWidth(rate: 0.9)
        graph.setBarAreaHeight(rate: 0.9)
        graph.setMaxChartValue(rate: 0.8)
        graph.setComponentArea(width: 60)
        
        graph.comparisonValue = 100000
        graph.setComparisonValueLine(color: UIColor.init(red: 0.1, green: 0.1, blue: 0.15, alpha: 1.0))
        graph.setComparisonValueLabel(backgroundColor: UIColor.init(red: 0.2, green: 0.8, blue: 0.4,alpha: 0.9))
        
        // load Graph on ScrollView
        graph.loadChart()
        view.addSubview(graph)
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
           graph.comparisonValue = CGFloat(Int(text) ?? 0)
        }
        // 再描画
        graph.reloadChart()
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




