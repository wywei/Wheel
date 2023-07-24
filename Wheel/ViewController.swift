//
//  ViewController.swift
//  Wheel
//
//  Created by andy on 2023/7/9.
//

import UIKit

class ViewController: UIViewController {
    
    @IBAction func rotationClicked(_ sender: UIButton) {
        wheelView.rotation()
    }
    
    @IBAction func stopClicked(_ sender: UIButton) {
        wheelView.stop()
    }
    
    lazy var wheelView: WheelView = {
        let v = WheelView(frame: CGRect(x: 0, y: 0, width: 286, height: 286))
//        let v = WheelView.instantiate()
        v.center = self.view.center
        return v
    }()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        view.addSubview(wheelView)
    }


}

