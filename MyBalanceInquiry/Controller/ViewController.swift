//
//  ViewController.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/20.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    
    @IBOutlet weak var myBanktableView: UITableView!
    
    var superBank: BankManager?
    
    var selectedBank: Bank?
    
    var isFirstLoad = true
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // 初めてのロードであれば、初期設定を行う
        if isFirstLoad {
            setBanking()
        }
        
        myBanktableView.delegate = self
        myBanktableView.dataSource = self
        
    }
    
    // 初期データを設定
    private func setBanking() {
        
        // 銀行を追加
        let myBank1 = Bank(name: "みずほ銀行", firstBalance: 100000)
        let myBank2 = Bank(name: "三菱東京UFJ銀行", firstBalance: 200000)
        let myBank3 = Bank(name: "多摩信用金庫", firstBalance: 1200000)
        
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 取引を追加
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/04"), banking: .withdrawal, amount: 24000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/10"), banking: .payment, amount: 30000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/20"), banking: .withdrawal, amount: 15000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/25"), banking: .withdrawal, amount: 10000)
        
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/04"), banking: .withdrawal, amount: 27000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/10"), banking: .payment, amount: 30000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/23"), banking: .withdrawal, amount: 5000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/30"), banking: .withdrawal, amount: 10000)
        
        // 外部からの収入
        for month in 1...12 {
            myBank2.addBanking(date: dateFormatter.date(from: "2016/\(month)/04"), banking: .payment, amount: 80000)
        }
        
        for data in myBank2.bankStatement {
            data.setIncome()
        }
        
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/10"), banking: .withdrawal, amount: 50000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/13"), banking: .withdrawal, amount: 20000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/17"), banking: .withdrawal, amount: 10000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/22"), banking: .withdrawal, amount: 20000)
        
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/11"), banking: .withdrawal, amount: 30000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/21"), banking: .withdrawal, amount: 20000)
        
        myBank3.addBanking(date: dateFormatter.date(from: "2015/08/05"), banking: .withdrawal, amount: 10000)
        
        myBank3.addBanking(date: dateFormatter.date(from: "2016/09/09"), banking: .withdrawal, amount: 13000)
        myBank3.addBanking(date: dateFormatter.date(from: "2016/09/21"), banking: .withdrawal, amount: 29000)
        
//        print(myBank1.balance)
//        print(myBank2.balance)
//        print(myBank3.balance)
        
        // 全ての銀行を管理
        let superBank = BankManager(banks: [myBank1, myBank2, myBank3])
        self.superBank = superBank
        
//        print("合計残高：\(superBank.totalBalance)")
//        
//        print("8月の収支：\(superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: "2016/08/01"), toDate: dateFormatter.date(from: "2016/09/01")))")
//        print("9月の収支：\(superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: "2016/09/01"), toDate: dateFormatter.date(from: "2016/10/01")))")
        
    }
    
    // My銀行を追加登録するボタンが押された時
    @IBAction func tapAddNewBankButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toAddNewBank", sender: nil)
    }
    
    @IBAction func tapGraghViewButton(_ sender: UIButton) {
        performSegue(withIdentifier: "toGraghView", sender: nil)
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSourceのメソッド

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superBank?.banks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
        guard let superBank = superBank else {
            let cell: UITableViewCell = UITableViewCell()
            return cell
        }
        
        // セルを定義（ここではデフォルトのセル）
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = superBank.banks[indexPath.row].bankName
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBank = superBank?.banks[indexPath.row] else {
            return
        }
        performSegue(withIdentifier: "toMyBank", sender: selectedBank)
    }
    
}


// MARK: - 画面遷移に関する処理

extension ViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let myBankVC = segue.destination as? MyBankViewController, segue.identifier == "toMyBank" {
            // 遷移先にBankの参照先を渡す
            myBankVC.selectedBank = sender as? Bank
            
        } else if let newBankVC = segue.destination as? AddNewBankViewController, segue.identifier == "toAddNewBank" {
            // 遷移先にBankManagerの参照先を渡す
            newBankVC.superBank = self.superBank
        } else if let graghVC = segue.destination as? GraghViewController, segue.identifier == "toGraghView" {
            // 遷移先にBankManagerの参照先を渡す
            graghVC.superBank = self.superBank
        }
        
    }
    
    // 戻るボタンにより前画面へ遷移
    @IBAction func back(segue: UIStoryboardSegue) {
        print("back")
    }
    
}


















