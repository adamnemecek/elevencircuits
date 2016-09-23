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

    var circleLayer: CAShapeLayer!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let labyrinth = Labyrinth(amountCircuits: 11)
        
        let timeline = Timeline()
        
        let lengths = labyrinth.path.map { $0.length } + labyrinth.path.reversed().map { $0.length }
        
        
        print(lengths.map { $0 * 10 }.sum / 60)
            
        let cumulativeLengths = zip(
            lengths.cumulative.map { $0 * 10 },
            lengths.map { $0 * 10 }
        )
        
        lengths.forEach { print($0) }
            
        cumulativeLengths.forEach { (offset, length) in
            timeline.add(at: Double(offset)) { self.animateCircle(duration: Double(length)) }
        }
        
        timeline.start()
        
        let startAngle = CGFloat((3 * M_PI) / 2)
        let endAngle = startAngle + CGFloat(2 * M_PI)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: view.frame.size.width / 2.0, y: view.frame.size.height / 2.0),
            radius: (view.frame.size.width - 10) / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        self.circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5
        
        // don't draw yet
        circleLayer.strokeEnd = 0.0
        
        view.layer.addSublayer(circleLayer)
    }
    
    // TODO: animateCircle(radius:duration:)
    func animateCircle(duration: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        circleLayer.strokeEnd = 1.0
        circleLayer.add(animation, forKey: "animateCircle")
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
