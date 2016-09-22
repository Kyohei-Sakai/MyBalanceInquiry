//
//  MyBankViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class MyBankViewController: UIViewController {
    
    @IBOutlet weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankStatementTableView: UITableView!
    @IBOutlet weak var balanceLabel: UILabel!
    
    var selectedBank: Bank!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        bankNameLabel.text = selectedBank.bankName
        balanceLabel.text = "残高　¥ \(selectedBank.balance)"
        
        bankStatementTableView.delegate = self
        bankStatementTableView.dataSource = self
        
        bankStatementTableView.register(UINib(nibName: "BankStatementCell", bundle: nil), forCellReuseIdentifier: "StatementCell")
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    // 取引を追加するためのボタンが押された時
    @IBAction func tapAddButton(_ sender: UIButton) {
        // 遷移先のViewControllerに渡すBankを設定
        performSegue(withIdentifier: "toBankingViewController", sender: nil)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSourceのメソッド

extension MyBankViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBank!.bankStatement.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを定義
        let statementCell = tableView.dequeueReusableCell(withIdentifier: "StatementCell", for: indexPath) as! BankStatementCell
        
        let i = indexPath.row
        let bank = selectedBank.bankStatement
        
        statementCell.setCell(date: bank[i].date, banking: bank[i].banking, amount: bank[i].amount)
        
        return statementCell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 今のところ処理はなし
    }
    
}


// MARK: - 画面遷移に関する処理

extension MyBankViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if (segue.identifier == "toBankingViewController") {
            let BankingVC: BankingViewController = (segue.destination as? BankingViewController)!
            // 遷移先にBankの参照先を渡す
            BankingVC.selectedBank = self.selectedBank
        }
        
    }
    
    // 戻るボタンにより前画面へ遷移
    @IBAction func cancel(segue: UIStoryboardSegue) {
        print("cancel")
    }
    
}










