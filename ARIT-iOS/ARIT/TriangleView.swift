//
//  TriangleView.swift
//  ARIT
//
//  Thanks StackOverflow: https://stackoverflow.com/questions/30650343/triangle-uiview-swift
//

import UIKit

class TriangleView : UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    override func draw(_ rect: CGRect) {

        guard let context = UIGraphicsGetCurrentContext() else { return }

        context.beginPath()
        context.move(to: CGPoint(x: rect.minX, y: rect.minY))
        context.addLine(to: CGPoint(x: rect.maxX, y: rect.minY))
        context.addLine(to: CGPoint(x: (rect.maxX / 2.0), y: rect.maxY))
        context.closePath()

        context.setFillColor(red: 1.0, green: 0.5, blue: 0.0, alpha: 1.0)
        context.fillPath()
    }
}
