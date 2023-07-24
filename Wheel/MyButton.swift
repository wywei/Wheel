//
//  MyButton.swift
//  Wheel
//
//  Created by andy on 2023/7/9.
//

import UIKit

class MyButton: UIButton {

   
    override func imageRect(forContentRect contentRect: CGRect) -> CGRect {
        let w: CGFloat = 40
        let h: CGFloat = 48
        let x: CGFloat = (self.bounds.size.width - w) * 0.5
        let y: CGFloat = 20
        return CGRect.init(x: x, y: y, width: w, height: h)
    }

}
