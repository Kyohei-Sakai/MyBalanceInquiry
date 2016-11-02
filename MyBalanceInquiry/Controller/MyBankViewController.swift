//
//  MyBankViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class MyBankViewController: UIViewController {
    
    @IBOutlet fileprivate weak var bankNameLabel: UILabel!
    @IBOutlet weak var bankStatementTableView: UITableView!
    @IBOutlet fileprivate weak var balanceLabel: UILabel!
    
    var selectedBank: Bank?
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationItem.title = "残高照会"
        
        bankStatementTableView.register(UINib(nibName: "BankStatementCell", bundle: nil), forCellReuseIdentifier: "StatementCell")
        
        bankStatementTableView.delegate = self
        bankStatementTableView.dataSource = self
        
        bankNameLabel.text = selectedBank?.bankName
        if let balance = selectedBank?.balance {
            balanceLabel.text = "残高　¥ \(balance)"
            print("残高を更新しました。")
        }
    }
    
    // 取引を追加するためのボタンが押された時
    @IBAction private func tapAddButton(_ sender: UIButton) {
        // 遷移先のViewControllerに渡すBankを設定
        performSegue(withIdentifier: "toBankingViewController", sender: nil)
    }
    
}


// MARK: - UITableViewDelegate, UITableViewDataSourceのメソッド

extension MyBankViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return selectedBank?.bankStatement.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
        // カスタムセルを定義
        guard let statementCell = tableView.dequeueReusableCell(withIdentifier: "StatementCell", for: indexPath) as? BankStatementCell else {
            return UITableViewCell()
        }
        
        if let count = selectedBank?.bankStatement.count, let statement = selectedBank?.bankStatement[count - (1 + indexPath.row)] {
            // 最後の要素から順に呼び出す
            statementCell.setCell(data: statement)
        }
        
        return statementCell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("セル\(indexPath.row)を選択")
        if let count = selectedBank?.bankStatement.count, let statement = selectedBank?.bankStatement[count - (1 + indexPath.row)], statement.banking == .payment {
            // 最後の要素から順にセルに格納されている
            // 入金データであるかどうか
            alertIsIncome(data: statement)
        }
        
    }
    
    private func alertIsIncome(data: BankingData) {
        
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
        
        if let BankingVC = segue.destination as? BankingViewController, segue.identifier == "toBankingViewController" {
            // 遷移先にBankの参照先を渡す
            BankingVC.selectedBank = self.selectedBank
        }
        
    }
    
}










