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
    var bankStatement: [BankingData]?
    
    
    init(name: String, firstBalance: Int) {
        bankName = name
        self.firstBalance = firstBalance
        balance = self.firstBalance
    }
    
    func addBanking(date: Date?, banking: Banking, amount: Int?) {
        // 引数のnilチェック
        guard let date = date, let amount = amount else {
            print("取引データが正しくありません。")
            return
        }
        
        let data = BankingData(date: date, banking: banking, amount: amount)
        
        // プロパティのnilチェック
        guard var bankStatement = self.bankStatement else {
            // nilだったら最初の要素として初期化
            self.bankStatement = [data]
            return
        }
        
        // 日付順にデータを並び替えて格納する
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        let count = bankStatement.count
        var i = 1
        
        while (calendar.compare(date, to: bankStatement[count - i].date, toUnitGranularity: .day) == .orderedAscending) {
            
            i += 1
            
            if count < i{
                break
            }
        }
        
        
        // 残高を求める
        if banking == .payment {
            balance += amount
        } else {
            balance -= amount
        }
    }
    
    // 過去全ての取引を計算する
    fileprivate func getTotalBalance() -> Int {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return 0
        }
        
        var totalBalance = firstBalance
        
        bankStatement.forEach { data in
            if data.banking == .payment {
                totalBalance += data.amount
            } else {
                totalBalance -= data.amount
            }
        }
        return totalBalance
    }
    
    // 指定した期間の取引を計算する
    fileprivate func getTotalBalance(fromDate: Date!, toDate: Date!) -> Int {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return 0
        }
        
        var totalBalance = 0
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toUnitGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            exit(0)
        }
        
        bankStatement.forEach { data in
            
            let result1 = calendar.compare(data.date, to: fromDate, toUnitGranularity: .day)
            // data.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(data.date, to: toDate, toUnitGranularity: .day)
                // data.date < toDateであれば
                if result2 == .orderedAscending {
                    if data.banking == .payment {
                        totalBalance += data.amount
                    } else {
                        totalBalance -= data.amount
                    }
                }
            }
        }
        return totalBalance
    }
    
    
    
    // 取引明細を一覧で表示
    fileprivate func printBankStatement() {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return
        }
        
        bankStatement.forEach { data in
            print("\(data.date), \(data.banking), \(data.amount)")
        }
    }
    
    // 指定した日にちの取引のみを表示
    fileprivate func printBankStatement(fromDate: Date!) {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return
        }
        
        bankStatement.forEach { data in
            if data.date == fromDate {
                print("\(data.date), \(data.banking), \(data.amount)")
            }
        }
    }
    
    // 指定した期間の取引のみを表示
    fileprivate func printBankStatement(fromDate: Date!, toDate: Date!) {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return
        }
        
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toUnitGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            return;
        }
        
        bankStatement.forEach { data in
            
            let result1 = calendar.compare(data.date, to: fromDate, toUnitGranularity: .day)
            // i.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(data.date, to: toDate, toUnitGranularity: .day)
                // i.data < toDateであれば
                if result2 == .orderedAscending {
                    print("\(data.date), \(data.banking), \(data.amount)")
                }
            }
        }
    }
    
    // 取引日の最新を得る
    fileprivate var newDate: Date! {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return nil
        }
        return bankStatement.last!.date    }
    
    // 取引日の最古を得る
    fileprivate var oldDate: Date! {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return nil
        }
        return bankStatement.first!.date
    }
    
    // 指定した期間内での外部からの収入を得る
    fileprivate func getIncome(fromDate: Date!, toDate: Date!) -> Int {
        // プロパティのnilチェック
        guard let bankStatement = self.bankStatement else {
            return 0
        }
        
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        
        var income = 0
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            return income
        }
        
        bankStatement.forEach { data in
            
            let result1 = calendar.compare(data.date, to: fromDate, toGranularity: .day)
            // data.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(data.date, to: toDate, toGranularity: .day)
                // data.data < toDateであれば
                if result2 == .orderedAscending {
                    if data.isIncome {
                        income += data.amount
                    }
                }
            }
        }
        
        return income
    }
    
}


// 銀行取引の詳細をまとめたデータ
class BankingData {
    let date: Date
    let banking: Banking
    let amount: Int
    // 外部からの入金かどうか
    var isIncome: Bool = false
    
    init(date: Date, banking: Banking, amount: Int) {
        self.date = date
        self.banking = banking
        self.amount = amount
    }
    
    func setIncome() {
        if banking == .payment {
            isIncome = true
            print("\(date),\(amount)を\(isIncome)")
        }
    }
    
}


// 銀行取引の種類
enum Banking {
    // 入金
    case payment
    // 出金
    case withdrawal
}


// MARK: - Bankクラスをまとめて扱うクラス

class BankManager {
    var banks: [Bank]
    fileprivate var totalBalance = 0
    
    // 取引期間の最新と最古
    var mostNewDate: Date {
        let period = datePeriod()
        return period.last!
    }
    
    var mostOldDate: Date {
        let period = datePeriod()
        return period.first!
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
        var total = 0
        banks.forEach { total += $0.getTotalBalance() }
        return total
    }
    
    // 指定期間の収支バランスを求める
    func getSumTotalBalance(fromDate: Date!, toDate: Date!) -> Int {
        var total = 0
        banks.forEach { total += $0.getTotalBalance(fromDate: fromDate, toDate: toDate) }
        return total
    }
    
    // 全ての取引期間の最新値と最古値の候補を返す
    private func datePeriod() -> [Date] {
        
        var period: [Date?] = []
        
        for bank in banks {
            period.append(bank.oldDate)
            period.append(bank.newDate)
        }
        
        // nilを除いたDate配列を作る
        let datePeriod: [Date] = period.flatMap { $0 }
        
        // 日付順に並び替える
        let sortPeriod = datePeriod.sorted(by: { (date1: Date, date2: Date) -> Bool in
            let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
            return calendar.compare(date1, to: date2, toGranularity: .day) == .orderedAscending
        })
        
        return sortPeriod
    }
    
    // 指定した期間内での外部からの収入を得る
    func getTotalIncome(fromDate: Date!, toDate: Date!) -> Int {
        var income = 0
        banks.forEach { income += $0.getIncome(fromDate: fromDate, toDate: toDate) }
        return income
    }
    
}

















