//
//  BarGraghClass.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

// MARK: - BarGragh Class

class BarGragh: UIView {
    
    // データ配列
    private var dataArray: [Int] = []
    // データの中の最大支出 -> これをもとにBar表示エリアの高さを決める
    private var maxSpending: Int?
    // 生成するBarの幅
    private var barAreaWidth: CGFloat
    //
    private var oldDate: Date?
    
    private var average: Int
    private var averageX: CGFloat = 0
    private var averageY: CGFloat = 0
    // 比較するための設定値を表示
    var averageLabel: UILabel = UILabel()
    
    
    init(dataArray: [Int], oldDate: Date, barAreaWidth: CGFloat, height: CGFloat, average: Int) {
        self.dataArray = dataArray
        self.oldDate = oldDate
        maxSpending = dataArray.max()
        self.barAreaWidth = barAreaWidth
        self.average = average
        
        let width: CGFloat = barAreaWidth * CGFloat(dataArray.count)
        
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        super.init(frame: rect)
        self.backgroundColor = UIColor.white
    }
    
    // UIViewの継承時はこれがないとエラーになる
    required init?(coder aDecoder: NSCoder) {
        self.dataArray = []
        self.maxSpending = 0
        self.barAreaWidth = 0
        self.average = 0
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        let calendar = Calendar(identifier: .gregorian)
        
        for index in 0..<dataArray.count {
            
            // 任意のデータ数が収まる幅
            let height = rect.height
            // barの表示をずらしていく
            let x = CGFloat(index) * barAreaWidth
            
            if let oldDate = oldDate, let date = calendar.date(byAdding: DateComponents(month: index), to: oldDate), let maxSpending = maxSpending {
                let rect = CGRect(origin: CGPoint(x: x, y: 0), size: CGSize(width: barAreaWidth, height: height))
                
                let bar = Bar(rect, spending: dataArray[index], maxSpendig: maxSpending, date: date, average: average)
                self.addSubview(bar)
                
                self.averageY = bar.averageY
                
            }
            
        }
        
        drawLabel(x: averageX, y: averageY, width: 50, height: 20, text: String(average))
        
    }
    
    private func drawLabel(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, text: String) {
        let label: UILabel = UILabel()
        averageLabel = label
        label.frame = CGRect(x: x, y: y, width: width, height: height)
        label.text = text
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        self.addSubview(label)
    }

}


// MARK: - Bar Class

class Bar: UIView {
    // 各月の支出
    private var spending: Int
    private var maxSpendig: Int
    
    private var date: Date?
    private var average = 100000
    fileprivate var averageY: CGFloat = 0
    
    init(_ rect: CGRect, spending: Int, maxSpendig: Int, date: Date, average: Int) {
        self.spending = spending
        self.maxSpendig = maxSpendig
        self.date = date
        self.average = average
        super.init(frame: rect)
        self.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    // UIViewの継承時はこれがないとエラーになる
    required init?(coder aDecoder: NSCoder) {
        self.spending = 0
        self.maxSpendig = 0
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // barを表示するための領域の高さを求める -> rect領域を３分割
        // ここではrect領域の5分の4とする
        let barAreaHeight = rect.height / 5 * 4
        
        // barの高さを求める
        let barHeigth = barAreaHeight * CGFloat(spending) / CGFloat(maxSpendig)
        
        // barの始点のX座標（＝終点のX座標）
        let x = rect.width / 2
        
        // barの始点のY座標（上下に文字列表示用の余白がある）
        let y = barAreaHeight + (rect.height - barAreaHeight) / 2
        
        // barの終点のY座標
        let toY = y - barHeigth
        
        // barを表示
        drawBar(from: CGPoint(x: x, y: y), to: CGPoint(x: x, y: toY), width: rect.width / 2)
        
        // 上部に支出額を表示
        let labelHeight = (rect.height - barAreaHeight) / 2
        drawLabel(centerX: x, centerY: labelHeight / 2, width: rect.width, height: labelHeight, text: String("¥ \(spending)"))
        
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM"
        
        if let date = date {
            // 下部に月を表示
            drawLabel(centerX: x, centerY: rect.height - labelHeight / 2, width: rect.width, height: labelHeight, text: dateFormatter.string(from: date))
        }
        
        let averageHeight = barAreaHeight * CGFloat(average) / CGFloat(maxSpendig)
        let averageY = y - averageHeight
        self.averageY = averageY
        // 基準線を表示
        drawLine(from: CGPoint(x: 0, y: averageY), to: CGPoint(x: rect.width, y: averageY), width: 1)
        
    }
    
    private func drawBar(from: CGPoint, to: CGPoint, width: CGFloat) {
        let BarPath = UIBezierPath()
        BarPath.move(to: from)
        BarPath.addLine(to: to)
        BarPath.lineWidth = width
        UIColor.orange.setStroke()
        BarPath.stroke()
    }
    
    private func drawLabel(centerX x: CGFloat, centerY y: CGFloat, width: CGFloat, height: CGFloat, text: String) {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.center = CGPoint(x: x, y: y)
        label.text = text
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        label.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        self.addSubview(label)
    }
    
    private func drawLine(from: CGPoint, to: CGPoint, width: CGFloat) {
        let LinePath = UIBezierPath()
        LinePath.lineCapStyle = .round
        LinePath.move(to: from)
        LinePath.addLine(to: to)
        LinePath.lineWidth = width
        UIColor.red.withAlphaComponent(0.6).setStroke()
        LinePath.stroke()
    }
}






