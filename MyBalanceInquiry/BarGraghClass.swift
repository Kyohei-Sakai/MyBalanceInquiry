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
    var dataArray: [Int]
    var maxSpending: Int
    // 生成するBarの幅
    var barAreaWidth: CGFloat
    
    
    init(dataArray: [Int], barAreaWidth: CGFloat, height: CGFloat) {
        self.dataArray = dataArray
        self.maxSpending = dataArray.max()!
        self.barAreaWidth = barAreaWidth
        
        let width: CGFloat = barAreaWidth * CGFloat(dataArray.count)
        
        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
        super.init(frame: rect)
    }
    
    // UIViewの継承時はこれがないとエラーになる
    required init?(coder aDecoder: NSCoder) {
        self.dataArray = []
        self.maxSpending = 0
        self.barAreaWidth = 0
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    override func draw(_ rect: CGRect) {
        
        for i in 0..<dataArray.count {
            
            // 任意のデータ数が収まる幅
            let height = rect.height
            // barの表示をずらしていく
            let x = CGFloat(i) * self.barAreaWidth
            
            let rect = CGRect(origin: CGPoint(x: x, y: 0), size: CGSize(width: self.barAreaWidth, height: height))
            let bar = Bar(rect, spending: self.dataArray[i], maxSpendig: self.maxSpending, month: 6 + i)
            self.addSubview(bar)
            
        }
        
    }

}


// MARK: - Bar Class

class Bar: UIView {
    // 各月の支出
    var spending: Int
    var maxSpendig: Int
    
    var month: Int
    
    
    init(_ rect: CGRect, spending: Int, maxSpendig: Int, month: Int) {
        self.spending = spending
        self.maxSpendig = maxSpendig
        self.month = month
        super.init(frame: rect)
    }
    
    // UIViewの継承時はこれがないとエラーになる
    required init?(coder aDecoder: NSCoder) {
        self.spending = 0
        self.maxSpendig = 0
        self.month = 0
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    override func draw(_ rect: CGRect) {
        
        // barを表示するための領域の高さを求める -> rect領域を３分割
        // ここではrect領域の5分の4とする
        let barAreaHeight = rect.height / 5 * 4
        
        // barの高さを求める
        let barHeigth = barAreaHeight * CGFloat(self.spending) / CGFloat(self.maxSpendig)
        
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
        drawLabel(centerX: x, centerY: labelHeight / 2, width: rect.width, height: labelHeight, text: String("¥ \(self.spending)"))
        
        // 下部に月を表示
        drawLabel(centerX: x, centerY: rect.height - labelHeight / 2, width: rect.width, height: labelHeight, text: String("\(self.month)月"))
        
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
        label.backgroundColor = UIColor.lightGray
        self.addSubview(label)
    }
}
