//
//  Draw.swift
//  Kethan
//
//  Created by Sunil on 02/01/20.
//  Copyright © 2020 Arkenea. All rights reserved.
//
import UIKit

class Draw: UIView {

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.backgroundColor = .clear
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func draw(_ rect: CGRect) {
        let h = rect.height
        let w = rect.width
        let color: UIColor = UIColor.red

        let drect = CGRect(x: rect.origin.x, y: rect.origin.y, width: w, height: h)
        let bpath: UIBezierPath = UIBezierPath(rect: drect)
        bpath.lineWidth = 3.0
        color.set()
        bpath.stroke()

    }

}
