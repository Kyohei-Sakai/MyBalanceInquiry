//
//  BankStatementCell.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/21.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

class BankStatementCell: UITableViewCell {
    
    @IBOutlet weak var dateLabel: UILabel!
    @IBOutlet weak var bankingLabel: UILabel!
    @IBOutlet weak var amountLabel: UILabel!
    

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setCell(date: Date, banking: Banking, amount: Int) {
        // DateをStringに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM/dd"
        
        // 日付を表示
        let dateText = dateFormatter.string(from: date)
        dateLabel.text = dateText
        
        // 入金 or 出金を表示
        switch banking {
        case .Payment:
            bankingLabel.text = "入"
            bankingLabel.textColor = UIColor.blue
        case .Withdrawal:
            bankingLabel.text = "出"
            bankingLabel.textColor = UIColor.red
        }
        
        // 金額を表示
        amountLabel.text = "¥ \(amount)"
        
    }
    
}
