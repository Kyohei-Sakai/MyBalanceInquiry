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
        
        bankStatementTableView.register(UINib(nibName: "BankStatementCell", bundle: nil), forCellReuseIdentifier: "StatementCell")
        
        bankStatementTableView.delegate = self
        bankStatementTableView.dataSource = self
        
        bankNameLabel.text = selectedBank.bankName
        balanceLabel.text = "残高　¥ \(selectedBank.balance)"
        print("残高を更新しました。")
        
        
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
        let count = selectedBank.bankStatement.count
        // 最後の要素から順に呼び出す
        let statement = selectedBank.bankStatement[count - (1 + i)]
        
        statementCell.setCell(data: statement)
        return statementCell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル\(indexPath.row)を選択")
        let i = indexPath.row
        let count = selectedBank.bankStatement.count
        // 最後の要素から順にセルに格納されている
        let statement = selectedBank.bankStatement[count - (1 + i)]
        // 入金データであるかどうか
        if statement.banking == .payment {
            alerIsIncome(data: statement)
        }
        
    }
    
    func alerIsIncome(data: BankingData) {
        
        let alertController = UIAlertController(
            title: "取引の設定",
            message: "この取引を外部からの収入として扱いますか？",
            preferredStyle: .actionSheet)
        
        let otherAction = UIAlertAction(title: "はい", style: .default, handler: { action in
            print("\(action.title)が押されました")
            print("\(data.date),\(data.banking),\(data.amount)")
            data.setIncome()
        })
        
        let cancelAction = UIAlertAction(title: "いいえ", style: .cancel, handler: { action in
            print("\(action.title)が押されました")
        })
        
        alertController.addAction(otherAction)
        alertController.addAction(cancelAction)
        
        self.present(alertController, animated: true, completion: nil)
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










