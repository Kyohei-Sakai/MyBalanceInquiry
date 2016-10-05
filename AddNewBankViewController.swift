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
    
    var superBank: BankManager!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // Addボタンが押された時
    @IBAction func tapAddBank(_ sender: AnyObject) {
        
        let name = bankTextField.text!
        let firstBalance = Int(balanceTextField.text!)
        
        // 新しいBankを作成
        let newBank = Bank(name: name, firstBalance: firstBalance!)
        // BankManagerにBankを追加
        superBank.addBank(bank: newBank)
        
        for i in superBank.banks {
            print(i.bankName)
        }
        
        performSegue(withIdentifier: "toViewController", sender: nil)
        
    }
    
    
}


// MARK: - 画面遷移に関する処理

extension AddNewBankViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "toViewController") {
            let homeVC: ViewController = (segue.destination as? ViewController)!
            // 遷移先にBankManagerの参照先を渡す
            homeVC.superBank = self.superBank
            // 追加したBankが改めて初期設定されて消えるのを防ぐため
            homeVC.isFirstLoad = false
        }
    }
    
}











