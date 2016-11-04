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
	
	fileprivate var scrolView = UIScrollView()
    
    var superBank: BankManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "新規銀行登録"
        // backButtonを生成
//        self.navigationItem.leftBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: self, action: #selector(tapBackButton(_:)))
        
        configureScrollView()
        configurebankTextFeid()
        configurebalanceTextFeid()
    }
    
    // Addボタンが押された時
    @IBAction private func tapAddBank(_ sender: AnyObject) {
        guard let superBank = superBank, let name = bankTextField.text, let balanceText = balanceTextField.text else { return }
        
        if !name.isEmpty, !balanceText.isEmpty, let firstBalance = Int(balanceText) {
            // BankManagerにBankを追加
            superBank.add(bank: Bank(name: name, firstBalance: firstBalance))
            superBank.banks.forEach { print($0.bankName) }
            
            backTransition()
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
    
    @objc private func doneButtonDidPush(_ sender: UIButton) {
        // キーボードを閉じる
        balanceTextField.resignFirstResponder()
    }
    
}


// MARK: - UITextFieldDelegate method

extension AddNewBankViewController: UITextFieldDelegate {
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // retrueKeyを押すとキーボードが引っ込む
        textField.resignFirstResponder()
        return true
    }
    
}


// MARK: - 画面遷移に関する処理

extension AddNewBankViewController {
    // NavigationのbackButtonが押された時
//    @objc fileprivate func tapBackButton(_ sender: UIBarButtonItem) {
//        print("tapBackButton")
//        backTransition()
//    }
    
    // 前の画面に遷移する際の処理
    fileprivate func backTransition() {
        if let _ = self.navigationController?.popViewController(animated: true) {}
        
//        if let _ = self.navigationController?.popViewController(animated: true), let rootVC = self.navigationController?.topViewController as? ViewController {
//            // 遷移先にBankManagerの参照先を渡す
//            rootVC.superBank = self.superBank
//            // TableViewを再度読み込む
//            rootVC.myBanktableView.reloadData()
//        }
    }
    
}


// MARK: - UIScrollViewDelegate method

extension AddNewBankViewController: UIScrollViewDelegate {
    
}









