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
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.title = "銀行一覧"
        
        setBanking()
        
        myBanktableView.delegate = self
        myBanktableView.dataSource = self
        
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        myBanktableView.reloadData()
    }
    
    // 初期データを設定
    private func setBanking() {
        
        // 銀行を追加
        let myBank1 = Bank(type: .mizuho,     firstBalance: 10000)
        let myBank2 = Bank(type: .mitsubishi, firstBalance: 10000)
        let myBank3 = Bank(type: .mitsui,     firstBalance: 10000)
        
        setupBankingData(bank: myBank1, path: "mizuho")
        setupBankingData(bank: myBank2, path: "mitsubishi")
        setupBankingData(bank: myBank3, path: "mitsui")
        
        myBank1.bankStatement.forEach { data in
            if data.banking == .deposit {
                data.setIncome(!data.isIncome)
            }
        }
        myBank2.bankStatement.forEach { data in
            if data.banking == .deposit {
                data.setIncome(!data.isIncome)
            }
        }
        myBank3.bankStatement.forEach { data in
            if data.banking == .deposit {
                data.setIncome(!data.isIncome)
            }
        }
        
        
        // 全ての銀行を管理
        let superBank = BankManager(banks: [myBank1, myBank2, myBank3])
        self.superBank = superBank
    }
    
    // My銀行を追加登録するボタンが押された時
    @IBAction private func tapAddNewBankButton(_ sender: UIButton) {
        performSegue(withSegueType: .addBank, sender: nil)
    }
    
    @IBAction private func tapGraghViewButton(_ sender: UIButton) {
        performSegue(withSegueType: .gragh, sender: nil)
    }
    
    private func setupBankingData(bank: Bank, path: String) {
        var csvArray: [String] = []
        // CSVファイル名を引数にしてloadCSVメソッドを使用し、CSVファイルを読み込む
        csvArray = loadCSV(path)
        
        for index in 1..<csvArray.count - 1 {
            // csvArrayの任意の行を取り出し、カンマを区切りとしてaryに格納
            let banking = csvArray[index].removed(text: "\r").components(separatedBy: ",")
            
            // String -> Date
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy/MM/dd"
            let date = dateFormatter.date(from: banking[0])
            
            // String -> Banking
            var type: BankingData.Banking?
            
            switch banking[1] {
            case "d": type = .deposit
            case "w": type = .withdrawal
            default : type = nil
            }
            
            // String -> Int
            let amount = Int(banking[2])
            
            if let date = date, let type = type, let amount = amount {
                // 入力されたデータより取引明細を追加
                bank.addBanking(date: date, banking: type, amount: amount)
            }
            
        }
        
    }
    
    //CSVファイルの読み込みメソッド
    private func loadCSV(_ fileName :String) -> [String] {
        
        // CSVファイルのデータを格納するためのString型配列を宣言
        var csvArray: [String] = []
        
        do {
            // CSVファイルのパスを取得する。
            let csvPath = Bundle.main.path(forResource: fileName, ofType: "csv")
            
            // CSVファイルのデータを取得する。
            let csvData = try String(contentsOfFile:csvPath!, encoding:String.Encoding.utf8)
            
            // 改行区切りでデータを分割して配列に格納する。
            csvArray = csvData.components(separatedBy: "\n")
            
        } catch {
            print(error)
        }
        
        return csvArray
    }
    
    
}

// MARK: - UITableViewDelegate, UITableViewDataSourceのメソッド

extension ViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return superBank?.banks.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt  indexPath: IndexPath) -> UITableViewCell {
        guard let superBank = superBank else {
            let cell = UITableViewCell()
            return cell
        }
        
        // セルを定義（ここではデフォルトのセル）
        let cell = UITableViewCell(style: .default, reuseIdentifier: "Cell")
        cell.textLabel?.text = superBank.banks[indexPath.row].bankName
        
        return cell
    }
    
    // セルが選択された時の処理
    func tableView(_ table: UITableView, didSelectRowAt indexPath: IndexPath) {
        guard let selectedBank = superBank?.banks[indexPath.row] else {
            return
        }
        
        performSegue(withSegueType: .bank, sender: selectedBank)
    }
    
}


// MARK: - 画面遷移に関する処理

extension ViewController {
    // Segue 準備
    override func prepare(for segue: UIStoryboardSegue, sender: Any!) {
        
        if let myBankVC = segue.destination as? MyBankViewController, segue.identifier ==  SegueType.bank.rawValue {
            // 遷移先にBankの参照先を渡す
            myBankVC.selectedBank = sender as? Bank
        } else if let newBankVC = segue.destination as? AddNewBankViewController, segue.identifier == SegueType.addBank.rawValue {
            // 遷移先にBankManagerの参照先を渡す
            newBankVC.superBank = self.superBank
        } else if let graghVC = segue.destination as? GraghViewController, segue.identifier == SegueType.gragh.rawValue {
            // 遷移先にBankManagerの参照先を渡す
            graghVC.superBank = self.superBank
        }
        
    }
    
}


extension String {
    var removeLineFeed: String {
        if let lineFeed = self.characters.index(of: "\r") {
            return String(self.characters.prefix(upTo: lineFeed))
        }
        
        return self
    }
    
    // 指定した文字列があれば、それを取り除いて返す
    func removed(text: String) -> String {
        var string = self
        
        while let range = string.range(of: text) {
            
            let substringStartIndex = range.lowerBound
            let substringEndIndex = range.upperBound
            
            let selfStartIndex = string.startIndex
            let beforeString = string.substring(with: selfStartIndex..<substringStartIndex)
            
            let afterString = string.substring(from: substringEndIndex)
            
            string = beforeString + afterString
        }
        
        return string
    }
}



