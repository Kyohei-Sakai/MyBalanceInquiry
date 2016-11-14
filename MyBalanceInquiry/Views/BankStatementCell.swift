//
//  BankStatementCell.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class BankStatementCell: UITableViewCell {
    
    @IBOutlet fileprivate weak var dateLabel: UILabel!
    @IBOutlet fileprivate weak var bankingLabel: UILabel!
    @IBOutlet fileprivate weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
        // Configure the view for the selected state
    }
    
    // 取引日、入金か出金、金額を表示する
    func setCell(data: BankingData) {
        // DateをStringに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 日付を表示
        let dateText = dateFormatter.string(from: data.date)
        dateLabel.text = dateText
        
        // 入金 or 出金を表示
        switch data.banking {
        case .payment:
            bankingLabel.text = "入"
            bankingLabel.textColor = UIColor.blue
        case .withdrawal:
            bankingLabel.text = "出"
            bankingLabel.textColor = UIColor.red
        }
        
        // 金額を表示
        amountLabel.text = "¥ \(data.amount)"
        
        if data.isIncome == true {
            backgroundColor = UIColor.cyan
        }
        
    }
    
}







