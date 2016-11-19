//
//  BarGraghClass.swift
//  MyBalanceInquiry
//
//  Created by 酒井恭平 on 2016/09/26.
//  Copyright © 2016年 酒井恭平. All rights reserved.
//

import UIKit

// MARK: - GraghView Class

@IBDesignable final class GraghView: UIScrollView {
    
    // MARK: - Private properties
    
    // データの中の最大値 -> これをもとにBar表示領域の高さを決める
    private var maxGraghValue: CGFloat? { return graghValues.max() }
    
    // MARK: Setting ComparisonValue
    private var comparisonValueLabel = UILabel()
    private var comparisonValueLineView = UIView()
    private var comparisonValueX: CGFloat = 0
    private var comparisonValueY: CGFloat = 0
    
    
    // MARK: - Public properties
    
    // データ配列
    var graghValues: [CGFloat] = []
    // グラフのラベルに表示する情報
    var minimumDate: Date?
    
    var graghStyle: GraghViewCell.GraghStyle = .bar
    
    // MARK: Setting ComparisonValue
    
    @IBInspectable var comparisonValue: CGFloat = 100000
    
    @IBInspectable var comparisonValueIsHidden: Bool = false {
        didSet {
            comparisonValueLabel.isHidden = comparisonValueIsHidden
            comparisonValueLineView.isHidden = comparisonValueIsHidden
        }
    }
    
    // Delegate
//    var barDelegate: BarGraghViewDelegate?
    
    
    // MARK: - Initializers
    
    override init(frame: CGRect) {
        super.init(frame: frame)
    }
    
    convenience init(frame: CGRect, graghValues: [CGFloat], oldDate: Date) {
        self.init(frame: frame)
        self.graghValues = graghValues
        self.oldDate = oldDate
        self.graghStyle = style
        loadGraghView()
    }
    
    // storyboardで生成する時
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    
    // MARK: - Override
    
    override var contentOffset: CGPoint {
        didSet {
            if !comparisonValueIsHidden {
                // ComparisonValueLabelをスクロールとともに追従させる
                comparisonValueLabel.frame.origin.x = contentOffset.x
            }
        }
    }
    
    
    // MARK: - Private methods
    
    // MARK: Drawing
    
    private func drawComparisonValue() {
        drawComparisonValueLine(from: CGPoint(x: 0, y: comparisonValueY), to: CGPoint(x: contentSize.width, y: comparisonValueY))
        
        drawComparisonValueLabel(frame: CGRect(x: comparisonValueX, y: comparisonValueY, width: 50, height: 20), text: String(describing: comparisonValue))
    }
    
    private func drawComparisonValueLine(from statPoint: CGPoint, to endPoint: CGPoint) {
        // GraghViewと同じ大きさのViewを用意
        comparisonValueLineView.frame = CGRect(origin: CGPoint.zero, size: contentSize)
        comparisonValueLineView.backgroundColor = UIColor.clear
        // Lineを描画
        UIGraphicsBeginImageContextWithOptions(contentSize, false, 0)
        let linePath = UIBezierPath()
        linePath.lineCapStyle = .round
        linePath.move(to: statPoint)
        linePath.addLine(to: endPoint)
        linePath.lineWidth = GraghLayoutData.lineWidth
        GraghLayoutData.lineColor.setStroke()
        linePath.stroke()
        comparisonValueLineView.layer.contents = UIGraphicsGetImageFromCurrentImageContext()?.cgImage
        UIGraphicsEndImageContext()
        // GraghViewに重ねる
        addSubview(comparisonValueLineView)
    }
    
    private func drawComparisonValueLabel(frame: CGRect, text: String) {
        comparisonValueLabel.frame = frame
        comparisonValueLabel.text = text
        comparisonValueLabel.textAlignment = .center
        comparisonValueLabel.font = comparisonValueLabel.font.withSize(10)
        comparisonValueLabel.backgroundColor = GraghLayoutData.labelBackgroundColor
        addSubview(comparisonValueLabel)
    }
    
    
    // MARK: - Public methods
    
    func loadGraghView() {
        let calendar = Calendar(identifier: .gregorian)
        contentSize.height = frame.height
        
        for index in 0..<graghValues.count {
            if let oldDate = oldDate, let date = calendar.date(byAdding: DateComponents(month: index), to: oldDate), let maxGraghValue = maxGraghValue {
                // barの表示をずらしていく
                let rect = CGRect(origin: CGPoint(x: CGFloat(index) * GraghLayoutData.barAreaWidth, y: 0), size: CGSize(width: GraghLayoutData.barAreaWidth, height: frame.height))
                
                let bar = Bar(frame: rect, graghValue: graghValues[index], maxGraghValue: maxGraghValue, date: date, comparisonValue: comparisonValue)
                
                addSubview(bar)
                contentSize.width += bar.frame.width
                
                self.comparisonValueY = bar.comparisonValueY
            }
        }
        
        drawComparisonValue()
    }
    
    func reloadGraghView() {
        // GraghViewの初期化
        subviews.forEach { $0.removeFromSuperview() }
        contentSize = .zero
        
        loadGraghView()
    }
    
    func redrawComparisonValue() {
        comparisonValueLabel.frame.origin.x = contentOffset.x
    }
    // MARK: Set Gragh Customize
    
    func setBarArea(width: CGFloat) {
        GraghLayoutData.barAreaWidth = width
    }
    
    func setComparisonValueLabel(backgroundColor: UIColor) {
        GraghLayoutData.labelBackgroundColor = backgroundColor
    }
    
    func setComparisonValueLine(color: UIColor) {
        GraghLayoutData.lineColor = color
    }
    
    // BarのLayoutProportionはGraghViewから変更する
    func setBarAreaHeight(rate: CGFloat) {
        GraghViewCell.LayoutProportion.barAreaHeightRate = rate
    }
    
    func setMaxGraghValue(rate: CGFloat) {
        GraghViewCell.LayoutProportion.maxGraghValueRate = rate
    }
    
    func setBarWidth(rate: CGFloat) {
        GraghViewCell.LayoutProportion.barWidthRate = rate
    }
    
    func setBar(color: UIColor) {
        GraghViewCell.LayoutProportion.barColor = color
    }
    
    func setLabel(backgroundcolor: UIColor) {
        GraghViewCell.LayoutProportion.labelBackgroundColor = backgroundcolor
    }
    
    func setGragh(backgroundcolor: UIColor) {
        Bar.LayoutProportion.GraghBackgroundColor = backgroundcolor
    }
    
    
    // MARK: - Struct
    
    private struct GraghLayoutData {
        // 生成するBar領域の幅
        static var barAreaWidth: CGFloat = 50
        static var labelBackgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        static var lineColor = UIColor.red
        static var lineWidth: CGFloat = 2
        
    }
    
}


// MARK: - GraghViewCell Class

class GraghViewCell: UIView {
    
    // MARK: - Private properties
    
    // MARK: Shared
    
    // default is bar
    private var style: GraghStyle?
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
    }
    
    
    // MARK: - Initializers
    
    init(frame: CGRect, graghValue: CGFloat, maxGraghValue: CGFloat, date: Date, comparisonValue: CGFloat) {
        self.graghValue = graghValue
        self.maxGraghValue = maxGraghValue
        self.date = date
        self.comparisonValue = comparisonValue
        super.init(frame: frame)
        self.backgroundColor = LayoutProportion.GraghBackgroundColor
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
        guard let style = style else {
            return
        }
        
        if let toY = toY {
            // Graghを描画
            switch style {
            case .bar: drawBar(from: CGPoint(x: x, y: y), to: CGPoint(x: x, y: toY))
            case .round: drawRound(point: CGPoint(x: x, y: toY))
            }
        }
        
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
    
    // MARK: Drawing
    
    private func drawBar(from startPoint: CGPoint, to endPoint: CGPoint) {
        let BarPath = UIBezierPath()
        BarPath.move(to: startPoint)
        BarPath.addLine(to: endPoint)
        BarPath.lineWidth = barWidth
        LayoutProportion.barColor.setStroke()
        BarPath.stroke()
    }
    
    private func drawRound(point: CGPoint) {
        let origin = CGPoint(x: point.x - LayoutProportion.roundSize / 2, y: point.y - LayoutProportion.roundSize / 2)
        let size = CGSize(width: LayoutProportion.roundSize, height: LayoutProportion.roundSize)
        let round = UIBezierPath(ovalIn: CGRect(origin: origin, size: size))
        LayoutProportion.roundColor.setFill()
        round.fill()
        
    }
    
    private func drawLabel(centerX x: CGFloat, centerY y: CGFloat, width: CGFloat, height: CGFloat, text: String) {
        let label: UILabel = UILabel()
        label.frame = CGRect(x: 0, y: 0, width: width, height: height)
        label.center = CGPoint(x: x, y: y)
        label.text = text
        label.textAlignment = .center
        label.font = label.font.withSize(10)
        label.backgroundColor = LayoutProportion.labelBackgroundColor
        addSubview(label)
    }
    
    
    // MARK: - Struct
    
    // Barのレイアウトを決定するためのデータ
    fileprivate struct LayoutProportion {
        // MARK: Shared
        
        // barAreaHeight / frame.height
        static var barAreaHeightRate: CGFloat = 0.8
        // maxGraghValueRate / maxBarAreaHeight
        static var maxGraghValueRate: CGFloat = 0.8
        
        // MARK: Only Bar
        
        // bar.width / rect.width
        static var barWidthRate: CGFloat = 0.5
        // Bar Color
        static var barColor = UIColor.blue.withAlphaComponent(0.8)
        // Label backgroundColor
        static var labelBackgroundColor = UIColor.lightGray.withAlphaComponent(0.7)
        // Gragh backgroundColor
        static var GraghBackgroundColor = UIColor.orange.withAlphaComponent(0.5)
        
        // MARK: Only Round
        
        // round size
        static var roundSize: CGFloat = 10
        // round color
        static var roundColor = UIColor.red.withAlphaComponent(0.8)
    }
    
    
    // MARK: - Enumeration
    
    enum GraghStyle { case bar, round }
    
}














