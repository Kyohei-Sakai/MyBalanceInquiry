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
        
//        self.navigationItem.backBarButtonItem?.action = #selector(tapBackButton(_:))
        self.navigationItem.backBarButtonItem = UIBarButtonItem(title: "Back", style: .plain, target: nil, action: #selector(tapBackButton(_:)))
//        print(self.navigationItem.backBarButtonItem)
    }
    
    // Addボタンが押された時
    @IBAction private func tapAddBank(_ sender: AnyObject) {
        guard let superBank = superBank, let name = bankTextField.text, let balanceText = balanceTextField.text else { return }
        
        if !name.isEmpty, !balanceText.isEmpty, let firstBalance = Int(balanceText) {
            // BankManagerにBankを追加
            superBank.add(bank: Bank(name: name, firstBalance: firstBalance))
            superBank.banks.forEach { print($0.bankName) }
        } else {
            alertError()
        }
        
    }
    
    // 入力事項に誤りがあることをユーザに通知する
    private func alertError() {
        
        let alertController = UIAlertController(
            title: "エラー",
            message: "入力事項に不備があります。",
            preferredStyle: .actionSheet)
        
        let otherAction = UIAlertAction(title: "やり直す", style: .default, handler: { action in
            print("\(action.title)が押されました")
        })
        
        let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel, handler: { action in
            print("\(action.title)が押されました")
        })
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
    }
    
    // NavigationのbackButtonが押された時
    func tapBackButton(_ sender: UIBarButtonItem) {
        print("tapBackButton")
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











