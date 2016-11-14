//
//  BarGraghClass.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

// MARK: - BarGraghView Class

@IBDesignable final class BarGraghView: UIScrollView {
    
    // MARK: - Private properties
    
    // データの中の最大値 -> これをもとにBar表示領域の高さを決める
    private var maxGraghValue: CGFloat? { return graghValues.max() }
    
    // 比較値を設定
    private var comparisonValueLabel = UILabel()
    private var comparisonValueX: CGFloat = 0
    private var comparisonValueY: CGFloat = 0
    
    
    // MARK: - Public properties
    
    // データ配列
    var graghValues: [CGFloat] = []
    // 生成するBar領域の幅
    var barAreaWidth: CGFloat = 50
    // グラフのラベルに表示する情報
    var oldDate: Date?
    
    // 比較値を設定
    var comparisonValue: CGFloat = 100000
    
    var comparisonValueIsHidden: Bool = false {
        didSet {
            comparisonValueLabel.isHidden = comparisonValueIsHidden
        }
    }
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
//    init(graghValues: [Int], oldDate: Date, height: CGFloat) {
//        self.graghValues = graghValues
//        self.oldDate = oldDate
//        
//        let width: CGFloat = barAreaWidth * CGFloat(graghValues.count)
//        let rect = CGRect(origin: CGPoint.zero, size: CGSize(width: width, height: height))
//        self.init(frame: rect)
//    }
    
    // storyboardで生成する時
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    
//    override func draw(_ rect: CGRect) {
//    }
    
    
    // MARK: - Private methods
    
    private func drawComparisonValueLabel(x: CGFloat, y: CGFloat, width: CGFloat, height: CGFloat, text: String) {
        comparisonValueLabel.frame = CGRect(x: x, y: y, width: width, height: height)
        comparisonValueLabel.text = text
        comparisonValueLabel.textAlignment = .center
        comparisonValueLabel.font = comparisonValueLabel.font.withSize(10)
        comparisonValueLabel.backgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        addSubview(comparisonValueLabel)
    }
    
    private func drawComparisonValueLine(from: CGPoint, to: CGPoint, width: CGFloat) {
        let LinePath = UIBezierPath()
        LinePath.lineCapStyle = .round
        LinePath.move(to: from)
        LinePath.addLine(to: to)
        LinePath.lineWidth = width
        UIColor.red.withAlphaComponent(0.6).setStroke()
        LinePath.stroke()
    }
    
    
    // MARK: - Public methods
    
    func loadGraghView() {
        let calendar = Calendar(identifier: .gregorian)
        
        for index in 0..<graghValues.count {
            if let oldDate = oldDate, let date = calendar.date(byAdding: DateComponents(month: index), to: oldDate), let maxGraghValue = maxGraghValue {
                // barの表示をずらしていく
                let rect = CGRect(origin: CGPoint(x: CGFloat(index) * barAreaWidth, y: 0), size: CGSize(width: barAreaWidth, height: frame.height))
                
                let bar = Bar(frame: rect, graghValue: graghValues[index], maxGraghValue: maxGraghValue, date: date, comparisonValue: comparisonValue)
                
                addSubview(bar)
                contentSize.width += bar.frame.width
                
                self.comparisonValueY = bar.comparisonValueY
            }
        }
        
        drawComparisonValue()
    }
    
    func drawComparisonValue() {
        drawComparisonValueLine(from: CGPoint(x: 0, y: comparisonValueY), to: CGPoint(x: contentSize.width, y: comparisonValueY), width: 1)
        drawComparisonValueLabel(x: comparisonValueX, y: comparisonValueY, width: 50, height: 20, text: String(describing: comparisonValue))
    }
    
    func reloadComparisonValue() {
        comparisonValueLabel.frame.origin.x = contentOffset.x
    }
    
    // BarのLayoutProportionはBarGraghViewから変更する
    func setBarAreaHeight(rate: CGFloat) {
        Bar.LayoutProportion.barAreaHeightRate = rate
    }
    
    func setMaxGraghValue(rate: CGFloat) {
        Bar.LayoutProportion.maxGraghValueRate = rate
    }
    
    func setBarWidth(rate: CGFloat) {
        Bar.LayoutProportion.barWidthRate = rate
    }

}


// MARK: - Bar Class

class Bar: UIView {
    
    // MARK: - Private properties
    
    // 各月の支出
    private var graghValue: CGFloat
    private var maxGraghValue: CGFloat
    
    private var date: Date?
    private var comparisonValue: CGFloat = 0
    
    private var maxBarAreaHeight: CGFloat { return maxGraghValue / LayoutProportion.maxGraghValueRate }
    private var barAreaHeight: CGFloat { return frame.height * LayoutProportion.barAreaHeightRate }
    private var barWidth: CGFloat { return frame.width * LayoutProportion.barWidthRate }
    private var barHeigth: CGFloat { return barAreaHeight * graghValue / maxBarAreaHeight }
    
    // barの始点のX座標（＝終点のX座標）
    private var x: CGFloat { return frame.width / 2 }
    // barの始点のY座標（上下に文字列表示用の余白がある）
    private var y: CGFloat { return barAreaHeight + (frame.height - barAreaHeight) / 2 }
    // barの終点のY座標
    private var toY: CGFloat { return y - barHeigth }
    
    private var labelHeight: CGFloat { return (frame.height - barAreaHeight) / 2 }
    private var comparisonValueHeight: CGFloat { return barAreaHeight * comparisonValue / maxBarAreaHeight }
    
    
    // MARK: - FilePrivate properties
    
    fileprivate var comparisonValueY: CGFloat { return y - comparisonValueHeight }
    
    
    // MARK: - Struct
    
    // Barのレイアウトを決定するためのデータ
    fileprivate struct LayoutProportion {
        // barAreaHeight / frame.height
        static var barAreaHeightRate: CGFloat = 0.8
        // maxGraghValueRate / maxBarAreaHeight
        static var maxGraghValueRate: CGFloat = 0.8
        // bar.width / rect.width
        static var barWidthRate: CGFloat = 0.5
    }
    
    
    // MARK: - Initializers
    
    init(frame: CGRect, graghValue: CGFloat, maxGraghValue: CGFloat, date: Date, comparisonValue: CGFloat) {
        self.graghValue = graghValue
        self.maxGraghValue = maxGraghValue
        self.date = date
        self.comparisonValue = comparisonValue
        super.init(frame: frame)
        self.backgroundColor = UIColor.orange.withAlphaComponent(0.5)
    }
    
    // storyboardで生成する時
    required init?(coder aDecoder: NSCoder) {
        self.graghValue = 0
        self.maxGraghValue = 0
        super.init(coder: aDecoder)
//        fatalError("init(coder:) has not been implemented")
    }
    
    
    // MARK: - Override
    
    override func draw(_ rect: CGRect) {
        // barを表示
        drawBar(from: CGPoint(x: x, y: y), to: CGPoint(x: x, y: toY))
        
        // 上部に支出額を表示
        drawLabel(centerX: x, centerY: labelHeight / 2, width: rect.width, height: labelHeight, text: String("¥ \(graghValue)"))
        
        // StringをDateに変換するためのFormatterを用意
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy/MM"
        
        if let date = date {
            // 下部に月を表示
            drawLabel(centerX: x, centerY: rect.height - labelHeight / 2, width: rect.width, height: labelHeight, text: dateFormatter.string(from: date))
        }
        
    }
    
    
    // MARK: - Private methods
    
    private func drawBar(from: CGPoint, to: CGPoint) {
        let BarPath = UIBezierPath()
        BarPath.move(to: from)
        BarPath.addLine(to: to)
        BarPath.lineWidth = barWidth
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
        addSubview(label)
    }
    
}






