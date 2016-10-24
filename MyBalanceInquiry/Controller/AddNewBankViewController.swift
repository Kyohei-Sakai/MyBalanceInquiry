//
//  AddNewBankViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/22.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class AddNewBankViewController: UIViewController {
    
    @IBOutlet fileprivate weak var bankTextField: UITextField!
    @IBOutlet fileprivate weak var balanceTextField: UITextField!
    
    var superBank: BankManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configbankTextFeid()
        configbalanceTextFeid()
    }
    
    private func configbankTextFeid() {
        bankTextField.returnKeyType = .done
        bankTextField.clearButtonMode = .whileEditing
        bankTextField.delegate = self
    }
    
    private func configbalanceTextFeid() {
        balanceTextField.keyboardType = .numberPad
        balanceTextField.clearButtonMode = .whileEditing
        
        // ツールバーを生成
        let accessoryBar = UIToolbar()
        accessoryBar.sizeToFit()
        
        let doneBtn = UIBarButtonItem(title: "Done", style: .done, target: self, action: #selector(doneBtnDidPush(_:)))
        let spacer = UIBarButtonItem(barButtonSystemItem: .flexibleSpace, target: nil, action: nil)
        accessoryBar.setItems([spacer, doneBtn], animated: true)
        
        // ツールバーをtextViewのアクセサリViewに設定する
        balanceTextField.inputAccessoryView = accessoryBar
    }
    
    // Addボタンが押された時
    @IBAction private func tapAddBank(_ sender: AnyObject) {
        guard let superBank = superBank, let name = bankTextField.text, let balanceText = balanceTextField.text else { return }
        
        if !name.isEmpty, !balanceText.isEmpty, let firstBalance = Int(balanceText) {
            // BankManagerにBankを追加
            superBank.add(bank: Bank(name: name, firstBalance: firstBalance))
            superBank.banks.forEach { print($0.bankName) }
            
            performSegue(withIdentifier: "toViewController", sender: superBank)
        } else {
            alertError()
        }
        
    }
    
    // 入力事項に誤りがあることをユーザに通知する
    private func alertError() {
        
        let alertController = UIAlertController(title: "エラー", message: "入力事項に不備があります。", preferredStyle: .actionSheet)
        
        let otherAction = UIAlertAction(title: "やり直す", style: .default, handler: nil)
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: nil)
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    @objc private func doneBtnDidPush(_ sender: UIButton) {
        // キーボードを閉じる
        balanceTextField.resignFirstResponder()
    }
    
}


// MARK: - UITextFieldDelegate method

extension AddNewBankViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // retrueKeyを押すとキーボードが引っ込む
        if textField === bankTextField {
            textField.resignFirstResponder()
            return true
        } else {
            return false
        }
    }
    
}


// MARK: - 画面遷移に関する処理

extension AddNewBankViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let homeVC = segue.destination as? ViewController, segue.identifier == "toViewController" {
            // 遷移先にBankManagerの参照先を渡す
            homeVC.superBank = sender as? BankManager
            // 追加したBankが改めて初期設定されて消えるのを防ぐため
            homeVC.isFirstLoad = false
        }
    }
    
}











