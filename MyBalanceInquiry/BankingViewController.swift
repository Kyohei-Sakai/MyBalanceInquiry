//
//  BankingViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class BankingViewController: UIViewController {
    
    @IBOutlet weak var datePicker: UIPickerView!
    @IBOutlet weak var bankingPicker: UIPickerView!
    @IBOutlet weak var textField: UITextField!
    
    var selectedBank: Bank!
    
    var date: Date!
    var banking: Banking!
    var amount: Int!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        datePicker.delegate = self
        datePicker.dataSource = self
        datePicker.tag = 1
        
        bankingPicker.delegate = self
        bankingPicker.dataSource = self
        bankingPicker.tag = 2
        
        
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func tapAddButton(_ sender: UIButton) {
//        selectedBank.addBanking(date: <#T##Date!#>, banking: <#T##Banking#>, amount: <#T##Int#>)
        
        
        performSegue(withIdentifier: "fromBankingToVC", sender: nil)
        
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "fromBankingToVC") {
            let homeVC: ViewController = (segue.destination as? ViewController)!
            // 遷移先のViewControllerに設定したBankを渡す
            homeVC.selectedBank = self.selectedBank
        }
    }
    
    
}


// MARK - UIPickerViewDelegate, UIPickerViewDataSourceのメソッド

extension BankingViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    
    //コンポーネントの個数を返すメソッド
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        if pickerView.tag == 1 {
            // year, month, dayの3つのコンポーネント
            return 3
        } else {
            return 1
        }
        
    }
    
    //コンポーネントに含まれるデータの個数を返すメソッド
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        if pickerView.tag == 1 {
            switch component {
            case 0:
                // 2012~2016
                return 5
            case 1:
                return 12
            case 2:
                return 31
            default:
                return 0
            }
        } else {
            return 2
        }
        
    }
    
    //データを返すメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            switch component {
            case 0:
                let year: String = "20" + "\(16 - row)"
                return year
            case 1:
                let mounth: String = "\(row + 1)"
                return mounth
            case 2:
                let day: String = "\(row + 1)"
                return day
            default:
                return "error"
            }
        } else {
            let banking: [String] = ["入金", "出金"]
            return banking[row]
        }
        
    }
    
    
    //データ選択時の呼び出しメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        //コンポーネントごとに現在選択されているデータを取得する。
        
//        self.date = self.datePicker(pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0))
        
        
//        let data1 = self.pickerView(pickerView, titleForRow: pickerView.selectedRowInComponent(0), forComponent: 0)
//        let data2 = self.pickerView(pickerView, titleForRow: pickerView.selectedRowInComponent(1), forComponent: 1)
//        let data3 = self.pickerView(pickerView, titleForRow: pickerView.selectedRowInComponent(2), forComponent: 2)
//        
//        testLabel.text = "選択　\(data1!)　\(data2!)　\(data3!)"
    }
    
    
    
}















