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

    var circleLayer: CAShapeLayer!
    
    var leftWidth: CGFloat { return 0.382 * view.frame.width }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    
        createDivider()
        createCircleProgressBar()
    
        // TEST EQUALIZER
        let center = 0.5 * view.frame.width
        let width: CGFloat = 400
        
        let eq = GraphicEqualizerView(
            frame: CGRect(x: center - 0.5 * width, y: 400, width: 400, height: 200),
            amountBands: 10
        )
        
        view.layer.addSublayer(eq)
        
        // TEST MATRIX MIXER
        let mixer = MatrixMixerView(
            frame: CGRect(x: center - 0.5 * width, y: 650, width: width, height: width),
            amountInputs: 4,
            amountOutputs: 4
        )
        
        view.layer.addSublayer(mixer)
        
        // CREATE TIMELINE
        let timeline = Timeline()
        
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
                
                eq[slider].ramp(to: eqValue, over: Double(length))
                
                let input = UInt(Int.random(min: 0, max: 4))
                let output = UInt(Int.random(min: 0, max: 4))
                let sendValue = Float.random()
                
                mixer[input, output].ramp(to: sendValue, over: Double(length))
                
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
        view.layer.addSublayer(divider)
    }
    
    private func createCircleProgressBar() {
        
        let startAngle = CGFloat((3 * M_PI) / 2)
        let endAngle = startAngle + CGFloat(2 * M_PI)
        
        let circlePath = UIBezierPath(
            arcCenter: CGPoint(x: 0.5 * leftWidth, y: view.frame.height / 2.0),
            radius: (leftWidth - 50) / 2,
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
