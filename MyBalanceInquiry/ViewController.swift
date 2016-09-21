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
    
    
    // 銀行を追加
    let myBank1 = Bank(name: "みずほ銀行", firstBalance: 0)
    let myBank2 = Bank(name: "三菱東京UFJ銀行", firstBalance: 0)
    let myBank3 = Bank(name: "多摩信用金庫", firstBalance: 0)
    let specialBank = Bank(name: "Swift銀行", firstBalance: 10000)
    
    var superBank: BankManager = BankManager()
    
    var selectedBank: Bank?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 取引を追加
        myBank1.addBanking(date: dateFormatter.date(from: "2016/08/22"), banking: .Payment, amount: 3000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/02"), banking: .Payment, amount: 12000)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/10"), banking: .Withdrawal, amount: 500)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/12"), banking: .Payment, amount: 2100)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/13"), banking: .Withdrawal, amount: 3800)
        myBank1.addBanking(date: dateFormatter.date(from: "2016/09/06"), banking: .Withdrawal, amount: 8990)
        
        myBank2.addBanking(date: dateFormatter.date(from: "2016/08/02"), banking: .Payment, amount: 10000)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/09"), banking: .Withdrawal, amount: 3300)
        myBank2.addBanking(date: dateFormatter.date(from: "2016/09/21"), banking: .Withdrawal, amount: 2100)
        
        myBank3.addBanking(date: dateFormatter.date(from: "2016/08/02"), banking: .Withdrawal, amount: 1400)
        myBank3.addBanking(date: dateFormatter.date(from: "2016/09/09"), banking: .Withdrawal, amount: 1300)
        myBank3.addBanking(date: dateFormatter.date(from: "2016/09/21"), banking: .Withdrawal, amount: 1900)
        
        print(myBank1.balance)
        print(myBank2.balance)
        print(myBank3.balance)
        
        // 全ての銀行を管理
        let superBank = BankManager(bank: [myBank1, myBank2, myBank3])
        self.superBank = superBank
        print("合計残高：\(superBank.totalBalance)")
        
        print("8月の収支：\(superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: "2016/08/01"), toDate: dateFormatter.date(from: "2016/09/01")))")
        print("9月の収支：\(superBank.getSumTotalBalance(fromDate: dateFormatter.date(from: "2016/09/01"), toDate: dateFormatter.date(from: "2016/10/01")))")
        
        myBanktableView.delegate = self
        myBanktableView.dataSource = self
        
    }
    
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        if (segue.identifier == "toMyBankViewController") {
            let myBankVC: MyBankViewController = (segue.destination as? MyBankViewController)!
            // 遷移先のViewControllerに設定したBankを渡す
            myBankVC.selectedBank = self.selectedBank
        }
    }
    
    // 戻るボタンにより前画面へ遷移
    @IBAction func back(segue:UIStoryboardSegue) {
        print("back")
    }
    
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSourceのメソッド

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superBank.bank.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
        // セルを定義（ここではデフォルトのセル）
        let cell: UITableViewCell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = superBank.bank[indexPath.row].bankName
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        // 遷移先のViewControllerに渡すBankを設定
        self.selectedBank = superBank.bank[indexPath.row]
        performSegue(withIdentifier: "toMyBankViewController", sender: nil)
    }
    
}




















