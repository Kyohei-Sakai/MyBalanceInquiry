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
    
    // PickerViewに設定されている値を格納
    var pickDate: String!
    var pickBanking: String!
    
    
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
    
    // 必要事項を入力した後Addボタンで確定
    @IBAction func tapAddButton(_ sender: UIButton) {
        
        // String -> Date
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        let date = dateFormatter.date(from: self.pickDate)
        
        // String -> Banking
        var banking: Banking!
        if self.pickBanking == "入金" {
            banking = .payment
        } else if self.pickBanking == "出金" {
            banking = .withdrawal
        } else {
            banking = nil
        }
        
        // String -> Int
        let amount = Int(textField.text!)
        
        if date != nil && banking != nil && amount != nil {
            // 入力されたデータより取引明細を追加
            self.selectedBank.addBanking(date: date, banking: banking, amount: amount!)
            print("入力されたデータより取引明細を追加")
            // 更新後、明細画面に戻る
            self.performSegue(withIdentifier: "fromBankingToBank", sender: nil)
            print("セグエを呼ぶ")
            
        } else {
            print("未入力の項目があります。")
            alerError()
        }
        
    }
    
    // 入力事項に誤りがあることをユーザに通知する
    func alerError() {
        
        let alertController = UIAlertController(
            title: "エラー",
            message: "入力事項に誤りがあります。",
            preferredStyle: .actionSheet)
        
        let otherAction = UIAlertAction(title: "やり直す", style: .default, handler: { action in
            print("\(action.title)が押されました")
            
        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in
            print("\(action.title)が押されました")
//            self.performSegue(withIdentifier: "fromBankingToBank", sender: nil)
        })
        
        // Cancelは追加する順序に関わらず左側に表示される
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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
                // 2012~2016 + 「年」
                return 6
            case 1:
                // 1~12 + 「月」
                return 13
            case 2:
                // 1~31 + 「日」
                return 32
            default:
                return 0
            }
        } else {
            return 3
        }
        
    }
    
    //データを返すメソッド
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        if pickerView.tag == 1 {
            switch component {
            case 0:
                if row == 0 {
                    return String("年")
                } else {
                    let year: String = "20" + "\(17 - row)"
                    return year
                }
            case 1:
                if row == 0 {
                    return String("月")
                } else {
                    let mounth: String = "\(row)"
                    return mounth
                }
            case 2:
                if row == 0 {
                    return String("日")
                } else {
                    let day: String = "\(row)"
                    return day
                }
            default:
                return "error"
            }
        }
        else if pickerView.tag == 2 {
            let banking: [String] = ["未入力", "入金", "出金"]
            return banking[row]
        }
        else {
            return "error"
        }
        
    }
    
    
    //データ選択時の呼び出しメソッド
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        if pickerView.tag == 1 {
            //コンポーネントごとに現在選択されているデータを取得する
            let year = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
            
            let month = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 1), forComponent: 1)
            
            let day = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 2), forComponent: 2)
            
            self.pickDate = "\(year!)/\(month!)/\(day!)"
            print(self.pickDate)
            
        }
        else if pickerView.tag == 2 {
            let banking = self.pickerView(pickerView, titleForRow: pickerView.selectedRow(inComponent: 0), forComponent: 0)
            self.pickBanking = banking
            print(self.pickBanking)
        }
        
    }
    
}


// MARK: - 画面遷移に関する処理

extension BankingViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "fromBankingToBank") {
//            cal_money()
            let bankVC: MyBankViewController = (segue.destination as? MyBankViewController)!
            // 遷移先にBankの参照先を渡す
            bankVC.selectedBank = self.selectedBank
            print("遷移先にBankの参照先を渡す")
        }
    }
    
}














