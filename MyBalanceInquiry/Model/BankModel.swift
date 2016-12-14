//
//  BankClass.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import Foundation

// MARK: - BankType

enum BankType: String {
    case mizuho = "みずほ銀行"
    case mitsubishi = "三菱UFJ銀行"
    case mitsui = "三井住友銀行"
    case risona = "りそな銀行"
}


// MARK: - Bank Class

class Bank {
    
    // MARK: Private Properties
    
    // 初期残高を記録
    private let firstBalance: Int
    
    // MARK: Public Properties
    
    // 銀行名
    let bankName: String
    // 入出金データ
    var bankStatement: [BankingData] = []
    
    // 残高
    var balance: Int {
        return firstBalance + fluctuationAmount
    }
    
    // MARK: Initializers
    
    init(name: String, firstBalance: Int) {
        bankName = name
        self.firstBalance = firstBalance
    }
    
    convenience init(type: BankType, firstBalance: Int) {
        self.init(name: type.rawValue, firstBalance: firstBalance)
    }
    
    // MARK: Public Methods
    
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
    }
    
    // MARK: Fileprivate
    
    // MARK: Fluctuation Amount
    
    // 全ての取引の増減額
    fileprivate var fluctuationAmount: Int {
        return bankStatement.reduce(0) { value, data in
            switch data.banking {
            case .payment:      return value + data.amount
            case .withdrawal:   return value - data.amount
            }
        }
    }
    
    // 指定した期間の取引の増減額
    fileprivate func fluctuationAmount(fromDate: Date, toDate: Date) -> Int? {
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
    
    // MARK: Print
    
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
    
    // MARK: Date
    
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
    
    // MARK: Income
    
    // 指定した期間内での外部からの収入を得る
    fileprivate func income(fromDate: Date, toDate: Date) -> Int? {
        // fromData < toDateでなかった場合は強制終了
        guard fromDate < toDate else {
            print("期間設定に誤りがあります。")
            return nil
        }
        
        return bankStatement.filter { data in
            fromDate < data.date && data.date < toDate
            }.reduce(0) { value, data in
                guard let value = value else { return nil }
                
                if data.isIncome {
                    return value + data.amount
                } else {
                    return value
                }
        }
    }
    
    // MARK: Deposit
    
    // 指定した期間内での入金合計額
    fileprivate func deposit(fromDate: Date, toDate: Date) -> Int? {
        // fromData < toDateでなかった場合は強制終了
        guard fromDate < toDate else {
            print("期間設定に誤りがあります。")
            return nil
        }
        
        return bankStatement.filter { data in
            fromDate < data.date && data.date < toDate
            }.reduce(0) { value, data in
                guard let value = value else { return nil }
                return value + data.amount
        }
    }
    
}


// MARK: - BankingData

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
//            print("\(date),\(amount)を\(isIncome)")
        }
    }
    
    // 銀行取引の種類
    enum Banking {
        // 入金、出金
        case payment, withdrawal
    }
    
}


// MARK: - BankManager Class

class BankManager {
    var banks: [Bank] = []
    
    // MARK: Initializers
    
    init(banks: [Bank]) {
        self.banks = banks
    }
    
    // MARK: Add and Remove Bank
    
    // 銀行を追加
    func add(bank: Bank) {
        banks.append(bank)
    }
    
    // 銀行を削除
    func remove(bank: Bank) {
        var index = 0
        for existingBank in banks {
            if bank === existingBank {
                banks.remove(at: index)
                return
            }
            index += 1
        }
    }
    
    // MARK: Balance
    
    // 総残高
    var totalBalance: Int {
        return banks.flatMap { $0.balance }.reduce(0, +)
    }
    
    // MARK: Income
    
    // 指定した期間内での収入
    func totalIncome(fromDate: Date, toDate: Date) -> Int? {
        return banks.flatMap { $0.income(fromDate: fromDate, toDate: toDate) }.reduce(0, +)
    }
    
    // MARK: Deposit
    
    // 指定した期間内での入金
    func totalDeposit(fromDate: Date, toDate: Date) -> Int? {
        return banks.flatMap { $0.deposit(fromDate: fromDate, toDate: toDate) }.reduce(0, +)
    }
    
    
    // MARK: Fluctuation Amount
    
    // 全ての取引の総増減額（収支）
    fileprivate var sumFluctuationAmount: Int {
        return banks.flatMap { $0.fluctuationAmount }.reduce(0, +)
    }
    
    // 指定した期間内での収支
    func sumFluctuationAmount(fromDate: Date, toDate: Date) -> Int? {
        return banks.flatMap { $0.fluctuationAmount(fromDate: fromDate, toDate: toDate) }.reduce(0, +)
    }
    
    // MARK: Date
    
    // 取引期間の最新の日付
    var mostNewDate: Date? {
        return datePeriod.last
    }
    // 取引期間の最古の日付
    var mostOldDate: Date? {
        return datePeriod.first
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
        
        // nilを除いて日付順に並び替える
        return period.flatMap { $0 }.sorted(by: { (date1: Date, date2: Date) -> Bool in
            return date1 < date2
        })
    }
    
}

















