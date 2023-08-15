//
//  MainView.swift
//  gyroscope_paint
//
//  Created by Eli Burnes on 7/21/23.
//
import UIKit
import Foundation
import CoreGraphics
import PocketSVG

class MainView : UIView{
    var slidingRect: CGRect!
    var stamps = [LogoStamp]()
    var currentColor = UIColor.red.cgColor
    var pointerColor = UIColor.blue.cgColor
    var switchColor = false
    var logo: CGPath!
    
    init() {
        slidingRect = CGRect(x: 150, y: 60, width: 150, height: 30)
        print("init main view")
        super.init(frame: .zero)
        loadLogo()
    }
    
    func loadLogo(){
        let svgURL = Bundle.main.url(forResource: "logo", withExtension: "svg")!
        var logoPathArray = SVGBezierPath.pathsFromSVG(at: svgURL)

        var scaleFactor = 0.5;

        if let path = logoPathArray.first?.cgPath {
            var scaleTransform = CGAffineTransformMakeScale(scaleFactor, scaleFactor);
            var translation = CGAffineTransformMakeTranslation(300, 500)
            var transformConcat = CGAffineTransformConcat(translation, scaleTransform)
            var scaledLogo = path.copy(using: &transformConcat)
            
            if let logoFixed = scaledLogo{
                self.logo = logoFixed
            }
        }
        else{
            fatalError("could not load the logo SVG as a CG Path")
        }

        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    func updateRectangle(){
        slidingRect.origin.y += 5
        slidingRect.origin.x += 2
    }
    
    override func draw(_ rect: CGRect) {
        guard let context = UIGraphicsGetCurrentContext() else {
            return
        }
        context.clear(self.bounds)

        

        if (switchColor){
            currentColor = CGColor(red: CGFloat(arc4random()) / CGFloat(UInt32.max), green: CGFloat(arc4random()) / CGFloat(UInt32.max), blue: 250, alpha: 250)
            switchColor = false
        }
                        
        for stamp in stamps{
            context.beginPath()
            context.addPath(stamp.path)
            context.setFillColor(stamp.color)
            context.fillPath()
        }
        
        context.addPath(logo)
        context.setFillColor(UIColor.white.cgColor)
        context.fillPath()
        stamps.append(LogoStamp(path: logo, color: currentColor))

       // context.fillPath()
    }
}

