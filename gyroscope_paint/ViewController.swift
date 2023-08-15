//
//  ViewController.swift
//  gyroscope_paint
//
//  Created by Eli Burnes on 7/21/23.
//

import UIKit
import CoreMotion

class ViewController: UIViewController {
    
    var animationTimer : Timer?
    var mainView: MainView!
    var motion = CMMotionManager()
    var queue = OperationQueue()
    var rollScale:Double = 30
    var pitchScale:Double = 30

    var initialAttitude:CMAttitude?
    
    func startQueuedUpdates() {
       if motion.isDeviceMotionAvailable {
          self.motion.deviceMotionUpdateInterval = 1.0 / 60.0
          self.motion.showsDeviceMovementDisplay = true
           self.motion.startDeviceMotionUpdates(
                   to: self.queue, withHandler: { (data, error) in
           
            // Make sure the data is valid before accessing it.
             if let validData = data {
                 
                 if (self.initialAttitude == nil){
                     self.initialAttitude = validData.attitude.copy() as? CMAttitude
                 }
                 //adjust attitude data so that it is in proporation to the initial attitude.
                 //we may want to change this to a linear relation.
                 validData.attitude.multiply(byInverseOf: self.initialAttitude!)
                 
                 let roll = validData.attitude.roll
                 let pitch = validData.attitude.pitch
                 let yaw = validData.attitude.yaw
                 
                 DispatchQueue.main.sync {
                     let newX = self.mainView.logo.boundingBox.origin.x + (roll * self.rollScale)
                     let newY = self.mainView.logo.boundingBox.origin.y + (pitch * self.pitchScale)
                     
                     var xTranslation = 0.0
                     var yTranslation = 0.0
                     
                     if (newX > 0 && newX < self.view.frame.width - self.mainView.logo.boundingBox.width){
                         xTranslation = (roll * self.rollScale)
                     }
                     if (newY > 0 && newY < self.view.frame.height - self.mainView.logo.boundingBox.height){
                         yTranslation = (pitch * self.pitchScale)
                     }
                     
                     var translation = CGAffineTransformMakeTranslation(xTranslation, yTranslation)
                     self.mainView.logo = self.mainView.logo.copy(using: &translation)
                    
                     DispatchQueue.main.async {
                         self.mainView.setNeedsDisplay(self.mainView.bounds)
                     }
                 }
             }
          })
       }
    }

    override func viewWillAppear(_ animated: Bool) {
        if let delegate = UIApplication.shared.delegate as? AppDelegate {
            delegate.orientationLock = UIInterfaceOrientationMask.portrait
        }
    }
    
    override func loadView() {
        print("load view in view controller")

        super.loadView()
        mainView = MainView()
     //   mainView.backgroundColor = .white
        self.view = mainView
    }
    
    override func viewDidAppear(_ animated: Bool) {
        print("view did appear in view controller")
        super.viewDidAppear(animated)
        
        startQueuedUpdates()
    }
    
    @objc func handleTap(){
        self.mainView.switchColor = true
        DispatchQueue.main.async {
            self.mainView.setNeedsDisplay(self.mainView.bounds)
        }
    }
    
    @objc func updateRectangle(){
        print("update rectangle!!!")
        self.mainView.updateRectangle()
    }
    override func viewDidLoad() {
        super.viewDidLoad()
        let t = UITapGestureRecognizer(target: self, action: #selector(handleTap))
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(updateRectangle))
        view.addGestureRecognizer(swipe)
        view.addGestureRecognizer(t)
        t.cancelsTouchesInView = false
    }

}

