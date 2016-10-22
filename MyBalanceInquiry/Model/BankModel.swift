//
//  BankClass.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import Foundation


// MARK: - Bankクラス

class Bank {
    // 銀行名
    let bankName: String
    // 初期残高を記録
    private let firstBalance: Int
    // 残高
    var balance: Int
    // 入出金データ
    var bankStatement: [BankingData] = []
    
    
    init(name: String, firstBalance: Int) {
        bankName = name
        self.firstBalance = firstBalance
        balance = self.firstBalance
    }
    
    // 取引を追加し、入出金データに格納
    // StringからDateやIntに変換するため、引数をoptionalで定義
    func addBanking(date: Date?, banking: BankingData.Banking, amount: Int?) {
        guard let date = date, let amount = amount else {
            return
        }
        
        let data = BankingData(date: date, banking: banking, amount: amount)
        
        // 日付順にデータを並び替えて格納する
        // 配列が空でなければ
        if bankStatement.isEmpty {
            bankStatement.append(data)
            
        } else {
            let count = bankStatement.count
            var loop = 1
            
            while date < bankStatement[count - loop].date {
                
                loop += 1
                
                if count < loop {
                    break
                }
            }
            
            bankStatement.insert(data, at: count - loop + 1)
            
        }
        
        // 残高を求める
        if case .payment = banking {
            balance += amount
        } else {
            balance -= amount
        }
    }
    
    // 過去全ての取引を計算する
    fileprivate func getTotalBalance() -> Int {
        return bankStatement.reduce(0) { totalBalance, data in
            switch data.banking {
            case .payment:      return totalBalance + data.amount
            case .withdrawal:   return totalBalance - data.amount
            }
        }
    }
    
    // 指定した期間の取引を計算する
    fileprivate func getTotalBalance(fromDate: Date, toDate: Date) -> Int? {
        // fromData < toDateでなかった場合は強制終了
        guard fromDate < toDate else {
            print("期間設定に誤りがあります。")
            return nil
        }
        
        return bankStatement.filter { data in
            fromDate < data.date && data.date < toDate
            }.reduce(0) { totalBalance, data in
                switch data.banking {
                case .payment:      return totalBalance! + data.amount
                case .withdrawal:   return totalBalance! - data.amount
                }
        }
    }
    
    // 取引明細を一覧で表示
    fileprivate func printBankStatement() {
        bankStatement.forEach { data in
            print("\(data.date), \(data.banking), \(data.amount)")
        }
    }
    
    // 指定した日にちの取引のみを表示
    fileprivate func printBankStatement(fromDate: Date) {
        bankStatement.forEach { data in
            if data.date == fromDate {
                print("\(data.date), \(data.banking), \(data.amount)")
            }
        }
    }
    
    // 指定した期間の取引のみを表示
    fileprivate func printBankStatement(fromDate: Date, toDate: Date) {
        // fromData < toDateでなかった場合は強制終了
        guard fromDate < toDate else {
            print("期間設定に誤りがあります。")
            return
        }
        
        bankStatement.filter { data in
            fromDate < data.date && data.date < toDate
            }.forEach { data in
                print("\(data.date), \(data.banking), \(data.amount)")
        }
    }
    
    // 取引日の最新を得る
    fileprivate var newDate: Date? {
        if bankStatement.isEmpty {
            return nil
        } else {
            return bankStatement.last?.date
        }
    }
    
    // 取引日の最古を得る
    fileprivate var oldDate: Date? {
        if bankStatement.isEmpty {
            return nil
        } else {
            return bankStatement.first?.date
        }
    }
    
    // 指定した期間内での外部からの収入を得る
    fileprivate func getIncome(fromDate: Date, toDate: Date) -> Int? {
        // fromData < toDateでなかった場合は強制終了
        guard fromDate < toDate else {
            print("期間設定に誤りがあります。")
            return nil
        }
        
        return bankStatement.filter { data in
            fromDate < data.date && data.date < toDate
            }.reduce(0) { income, data in
                guard let income = income else { return nil }
                
                if data.isIncome {
                    return income + data.amount
                } else {
                    return income
                }
        }
    }
    
}


// 銀行取引の詳細をまとめたデータ
class BankingData {
    let date: Date
    let banking: Banking
    let amount: Int
    // 外部からの入金かどうか
    var isIncome = false
    
    init(date: Date, banking: Banking, amount: Int) {
        self.date = date
        self.banking = banking
        self.amount = amount
    }
    
    func setIncome() {
        if case .payment = banking {
            isIncome = true
            print("\(date),\(amount)を\(isIncome)")
        }
    }
    
    // 銀行取引の種類
    enum Banking {
        // 入金、出金
        case payment, withdrawal
    }
    
}


// MARK: - Bankクラスをまとめて扱うクラス

class BankManager {
    var banks: [Bank] = []
    fileprivate var totalBalance = 0
    
    // 取引期間の最新の日付
    var mostNewDate: Date? {
        return datePeriod.last
    }
    // 取引期間の最古の日付
    var mostOldDate: Date? {
        return datePeriod.first
    }
    
    
    init(banks: [Bank]) {
        self.banks = banks
        totalBalance = getSumTotalBalance()
    }
    
    // 銀行を追加
    func addBank(bank: Bank) {
        banks.append(bank)
        totalBalance = getSumTotalBalance()
    }
    
    // 合計残高を算出
    fileprivate func getSumTotalBalance() -> Int {
        return banks.reduce(0) { total, bank in
            total + bank.getTotalBalance()
        }
    }
    
    // 指定期間の収支バランスを求める
    func getSumTotalBalance(fromDate: Date, toDate: Date) -> Int? {
        return banks.flatMap { $0.getTotalBalance(fromDate: fromDate, toDate: toDate) }.reduce(0, +)
    }
    
    // 全ての取引期間の最新値と最古値の候補を返す
    private var datePeriod: [Date] {
        // 要素にnilが入り得る
        var period: [Date?] = []
        
        // 各Bankの最高値と最古値を格納
        banks.forEach { bank in
            period.append(bank.oldDate)
            period.append(bank.newDate)
        }
        
        // nilを除いたDate配列を作る
        let datePeriod: [Date] = period.flatMap { $0 }
        
        // 日付順に並び替える
        let sortPeriod = datePeriod.sorted(by: { (date1: Date, date2: Date) -> Bool in
            return date1 < date2
        })
        
        return sortPeriod
    }
    
    // 指定した期間内での外部からの収入を得る
    func getTotalIncome(fromDate: Date, toDate: Date) -> Int? {
        return banks.flatMap { $0.getIncome(fromDate: fromDate, toDate: toDate) }.reduce(0, +)
    }
    
}

















