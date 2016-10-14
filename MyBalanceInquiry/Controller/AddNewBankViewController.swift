//
//  AddNewBankViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/22.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class AddNewBankViewController: UIViewController {
    
    @IBOutlet weak var bankTextField: UITextField!
    @IBOutlet weak var balanceTextField: UITextField!
    
    var superBank: BankManager?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    // Addボタンが押された時
    @IBAction func tapAddBank(_ sender: AnyObject) {
        guard let superBank = superBank, let name = bankTextField.text, let balanceText = balanceTextField.text else {
            return
        }
        
        if let firstBalance = Int(balanceText) {
            // 新しいBankを作成
            let newBank = Bank(name: name, firstBalance: firstBalance)
            
            // BankManagerにBankを追加
            superBank.addBank(bank: newBank)
            
            superBank.banks.forEach { print($0.bankName) }
            
            performSegue(withIdentifier: "toViewController", sender: superBank)
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











