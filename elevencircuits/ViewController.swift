//
//  ViewController.swift
//  elevencircuits
//
//  Created by James Bean on 9/22/16.
//  Copyright © 2016 James Bean. All rights reserved.
//

import UIKit
import ArithmeticTools
import Labyrinth
import Timeline

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()

        let w: CGFloat = 40
        let center = view.frame.width / 2 - 0.5 * w
        let square = CAShapeLayer()
        square.path = UIBezierPath(rect: CGRect(x: center, y: 600, width: w, height: w)).cgPath
        square.fillColor = UIColor.red.cgColor
        view.layer.addSublayer(square)
        
        func on() {
            CATransaction.setDisableActions(true)
            square.fillColor = UIColor.white.cgColor
            CATransaction.setDisableActions(false)
        }
        
        func off() {
            CATransaction.setDisableActions(true)
            square.fillColor = UIColor.black.cgColor
            CATransaction.setDisableActions(false)
        }
        
        let labyrinth = Labyrinth(amountCircuits: 11)
        
        let timeline = Timeline()
        
        labyrinth.path
            .map { $0.length }
            .cumulative
            .map { $0 * 10 }
            .forEach {
                timeline.add(at: Double($0), action: on)
                timeline.add(at: Double($0 + 0.2), action: off)
            }
        
        timeline.start()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

