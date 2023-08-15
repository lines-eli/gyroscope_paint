//
//  NavController.swift
//  typo
//
//  Created by Eli Burnes on 7/21/23.
//

import UIKit

class NavController: UINavigationController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        pushViewController(ViewController(), animated: false)
    }
    
    
    /*
     // MARK: - Navigation
     
     // In a storyboard-based application, you will often want to do a little preparation before navigation
     override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
     // Get the new view controller using segue.destination.
     // Pass the selected object to the new view controller.
     }
     */
    
}

