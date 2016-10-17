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
import PathTools
import CompoundControllerView

class ViewController: UIViewController, F53OSCPacketDestination {

    let timeline = Timeline()
    var circleLayer: CAShapeLayer!
    var graphicEqualizer: GraphicEqualizerView!
    
    var leftWidth: CGFloat { return 0.382 * view.frame.width }
    var leftCenter: CGFloat { return 0.5 * leftWidth }
    var rightWidth: CGFloat { return view.frame.width - leftWidth }
    var rightCenter: CGFloat { return view.frame.width - (0.5 * rightWidth) }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        createDivider()
        createCircleProgressBar()
        createGraphicEqualizer()
        
        
        let labyrinth = Labyrinth(amountCircuits: 11)
        let lengths = labyrinth.path.map { $0.length } + labyrinth.path.reversed().map { $0.length }
        print(lengths.map { $0 * 10 }.sum / 60)
            
        let cumulativeLengths = zip(
            lengths.cumulative.map { $0 * 10 },
            lengths.map { $0 * 10 }
        )
        
        lengths.forEach { print($0) }
            
        cumulativeLengths.forEach { (offset, length) in
            timeline.add(at: Double(offset)) {
                
                let slider = UInt(Int.random(min: 0, max: 11))
                let eqValue = Float.random()
                
                self.graphicEqualizer[slider].ramp(to: eqValue, over: Double(length))
                self.animateCircle(duration: Double(length))
            }
        }
        
        timeline.start()
    }
    
    private func createDivider() {
        let divider = CAShapeLayer()
        let dividerPath = Path()
            .move(to: CGPoint(x: leftWidth, y: 0))
            .addLine(to: CGPoint(x: leftWidth, y: view.frame.height))
        divider.path = dividerPath.cgPath
        divider.lineWidth = 1
        divider.strokeColor = UIColor.white.cgColor
        divider.opacity = 0.5
        view.layer.addSublayer(divider)
    }
    
    private func createCircleProgressBar() {
        
        let startAngle = CGFloat((3 * M_PI) / 2)
        let endAngle = startAngle + CGFloat(2 * M_PI)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 0.5 * leftWidth, y: view.frame.height / 2.0),
            radius: (leftWidth - 100) / 2,
            startAngle: startAngle,
            endAngle: endAngle,
            clockwise: true
        )
        
        self.circleLayer = CAShapeLayer()
        circleLayer.path = circlePath.cgPath
        circleLayer.fillColor = nil
        circleLayer.strokeColor = UIColor.red.cgColor
        circleLayer.lineWidth = 5
        circleLayer.strokeEnd = 0.0
        
        view.layer.addSublayer(circleLayer)
    }
    
    private func createGraphicEqualizer() {
        let width = rightWidth - 200
        let height = 1/3 * width
        self.graphicEqualizer = GraphicEqualizerView(
            frame: CGRect(
                x: rightCenter - 0.5 * width,
                y: 0.5 * view.frame.height - 0.5 * height,
                width: width,
                height: height
            )
        )
        view.layer.addSublayer(graphicEqualizer)
    }
    
    // TODO: refactor this to `dn-m/ProgressBar` framework
    // TODO: animateCircle(radius:duration:)
    func animateCircle(duration: Double) {
        let animation = CABasicAnimation(keyPath: "strokeEnd")
        animation.duration = duration
        animation.fromValue = 0
        animation.toValue = 1
        circleLayer.strokeEnd = 1.0
        circleLayer.add(animation, forKey: "animateCircle")
    }
    
    func take(_ message: F53OSCMessage!) {
        print("message received")
        print(message.addressPattern)
        print(message.arguments)
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
