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
    var bankName:String
    // 初期残高を記録
    let firstBalance: Int
    // 残高
    var balance: Int
    // 入出金データ
    var bankStatement:[(date: Date, banking: Banking, amount: Int)] = []
    
    init() {
        self.bankName = ""
        self.firstBalance = 0
        self.balance = 0
    }
    
    init(name: String, firstBalance: Int) {
        self.bankName = name
        self.firstBalance = firstBalance
        self.balance = firstBalance
    }
    
    // 取引を追加し、入出金データに格納
    func addBanking(date: Date!, banking: Banking, amount: Int) {
        let data:(Date, Banking, Int) = (date, banking, amount)
        
        // 日付順にデータを並び替えて格納する
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // 配列が空でなければ
        if bankStatement.isEmpty {
            self.bankStatement.append(data)
            
        } else {
            let count = bankStatement.count
            var i = 1
            
            while (calendar.compare(date, to: bankStatement[count - i].date, toUnitGranularity: .day) == .orderedAscending) {
                
                i += 1
                
                if count < i{
                    break
                }
            }
            
            // Elementにdataを入れるとエラーになる（謎）
            self.bankStatement.insert((date, banking, amount), at: count - i + 1)
            
        }
        
        // 残高を求める
        if banking == Banking.payment {
            self.balance += amount
            print("2.bankclass: \(self.balance)")
        } else {
            self.balance -= amount
        }
    }
    
    // 過去全ての取引を計算する
    func getTotalBalance() -> Int {
        var totalBalance: Int = self.firstBalance
        
        for i in bankStatement {
            if i.banking == Banking.payment {
                totalBalance += i.amount
            } else {
                totalBalance -= i.amount
            }
        }
        return totalBalance
    }
    
    // 指定した期間の取引を計算する
    func getTotalBalance(fromDate: Date!, toDate: Date!) -> Int {
        var totalBalance: Int = 0
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toUnitGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            exit(0)
        }
        
        for i in bankStatement {
            
            let result1 = calendar.compare(i.date, to: fromDate, toUnitGranularity: .day)
            // i.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(i.date, to: toDate, toUnitGranularity: .day)
                // i.data < toDateであれば
                if result2 == .orderedAscending {
                    if i.banking == Banking.payment {
                        totalBalance += i.amount
                    } else {
                        totalBalance -= i.amount
                    }
                }
            }
        }
        return totalBalance
    }
    
    
    
    // 取引明細を一覧で表示
    func printBankStatement() {
        for i in bankStatement {
            print(i)
        }
    }
    
    // 指定した日にちの取引のみを表示
    func printBankStatement(fromDate: Date!) {
        for i in bankStatement {
            if i.date == fromDate {
                print(i)
            }
        }
    }
    
    // 指定した期間の取引のみを表示
    func printBankStatement(fromDate: Date!, toDate: Date!) {
        
        let calendar = NSCalendar(identifier: NSCalendar.Identifier.gregorian)!
        
        // fromData < toDateでなかった場合は強制終了
        if calendar.compare(fromDate, to: toDate, toUnitGranularity: .day) != .orderedAscending {
            print("期間設定に誤りがあります。")
            return;
        }
        
        for i in bankStatement {
            
            let result1 = calendar.compare(i.date, to: fromDate, toUnitGranularity: .day)
            // i.date > fromDateであれば
            if result1 == .orderedDescending {
                
                let result2 = calendar.compare(i.date, to: toDate, toUnitGranularity: .day)
                // i.data < toDateであれば
                if result2 == .orderedAscending {
                    print(i)
                }
            }
        }
    }
    
    // 取引日の最新を得る
    var newDate: Date! {
        if bankStatement.isEmpty {
            return nil
        } else {
            return bankStatement[bankStatement.endIndex - 1].date
        }
    }
    
    // 取引日の最古を得る
    var oldDate: Date! {
        if bankStatement.isEmpty {
            return nil
        } else {
            return bankStatement[0].date
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
    var bank: [Bank]
    var totalBalance: Int = 0
    
    // 取引期間の最新と最古
    var mostNewDate: Date!
    var mostOldDate: Date!
    
    init() {
        self.bank = []
    }
    
    init(bank: [Bank]) {
        self.bank = bank
        self.totalBalance = getSumTotalBalance()
        datePeriod()
    }
    
    // 銀行を追加
    func addBank(bank: Bank) {
        self.bank.append(bank)
        self.totalBalance = self.getSumTotalBalance()
        datePeriod()
    }
    
    // 合計残高を算出
    func getSumTotalBalance() -> Int {
        var total = 0
        
        for i in self.bank {
            total += i.getTotalBalance()
        }
        return total
    }
    
    // 指定期間の収支バランスを求める
    func getSumTotalBalance(fromDate: Date!, toDate: Date!) -> Int {
        var total = 0
        
        for i in self.bank {
            total += i.getTotalBalance(fromDate: fromDate, toDate: toDate)
        }
        return total
    }
    
    // 全ての取引期間の最新と最古を求める
    private func datePeriod() {
        let calendar = Calendar(identifier: Calendar.Identifier.gregorian)
        var datePeriod: [Date] = []
        
        for bank in self.bank {
            let period: [Date] = [bank.oldDate, bank.newDate]
            
            for data in period {
                // 配列が空でなければ
                if datePeriod.isEmpty {
                    datePeriod.append(data)
                    
                } else {
                    let count = datePeriod.count
                    var i = 1
                    
                    while (calendar.compare(data, to: datePeriod[count - i], toGranularity: .day) == .orderedAscending) {
                        
                        i += 1
                        
                        if count < i{
                            break
                        }
                    }
                    
                    // Elementにdataを入れるとエラーになる（謎）
                    datePeriod.insert(data, at: count - i + 1)
                    
                }
            }
        }
        
        self.mostNewDate = datePeriod[datePeriod.endIndex - 1]
        self.mostOldDate = datePeriod[0]
        
    }
    
}

















