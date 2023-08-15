//
//  PaintState.swift
//  gyroscope_paint
//
//  Created by Eli Burnes on 7/24/23.
//

import Foundation
import CoreGraphics

class PaintState{
    var slidingRect: CGRect!
    
    init(slidingRect: CGRect!) {
        self.slidingRect = slidingRect
    }
}

class LogoStamp{
    let path:CGPath
    let color:CGColor
    
    init(path: CGPath, color: CGColor) {
        self.path = path
        self.color = color
    }
}
