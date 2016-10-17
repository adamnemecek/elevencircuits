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
    var nanoKontrol: NanoKontrolView!
    
    var leftWidth: CGFloat { return 0.382 * view.frame.width }
    var leftCenter: CGFloat { return 0.5 * leftWidth }
    var rightWidth: CGFloat { return view.frame.width - leftWidth }
    var rightCenter: CGFloat { return view.frame.width - (0.5 * rightWidth) }
    
    var startButton: UIButton!
    var stopButton: UIButton!
    
    let lengths: [Double] = [
        
        15.9436, // 0
        14.2353,
        11.3883,
        
        14.8048, // 3
        9.11062,
        10.8189,
        25.0542,
        
        10.8189, // 7
        18.2212,
        7.40238,
        11.3883,
        
        7.40238, // 11
        9.11062,
        21.6377,
        12.5271,
        28.4707,
        15.9436,
        35.3036,
        19.3601,
        21.0683,
        45.5531,
        
        21.0683, // 21
        38.7201,
        17.6518,
        31.8872,
        
        17.6518, // 25
        19.3601,
        42.1366,
        45.5531,
        
        14.2353, // 29
        12.5271
    ]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        createStartButton()
        createStopButton()
        createDivider()
        createCircleProgressBar()
        createGraphicEqualizer()
        createNanoKontrol()
        setInitialValues()
        constructTimeline()
    }
    
    @objc private func start() {
        setInitialValues()
        timeline.start()
        startButton.removeFromSuperview()
        view.addSubview(stopButton)
    }
    
    @objc private func stop() {
        createCircleProgressBar()
        createNanoKontrol()
        createGraphicEqualizer()
        setInitialValues()
        timeline.stop()
        stopButton.removeFromSuperview()
        view.addSubview(startButton)
    }
    
    private func createStartButton() {
        let width: CGFloat = 300
        let left = leftCenter - 0.5 * width
        let height: CGFloat = 150
        let top = 0.5 * view.frame.height - 0.5 * height
        startButton = UIButton(frame: CGRect(x: left, y: top, width: width, height: height))
        startButton.setTitle("Start", for: .normal)
        startButton.setTitleColor(.white, for: .normal)
        startButton.titleLabel?.font = UIFont(name: "Avenir-Next", size: 18)
        startButton.layer.opacity = 0.5
        startButton.layer.borderWidth = 1
        startButton.layer.borderColor = UIColor.white.cgColor
        
        startButton.addTarget(self, action: #selector(start), for: .touchDown)

        view.addSubview(startButton)
    }
    
    private func createStopButton() {
        let width: CGFloat = 300
        let left = leftCenter - 0.5 * width
        let height: CGFloat = 150
        let top = 0.5 * view.frame.height - 0.5 * height
        stopButton = UIButton(frame: CGRect(x: left, y: top, width: width, height: height))
        stopButton.setTitle("Stop", for: .normal)
        stopButton.setTitleColor(.white, for: .normal)
        stopButton.titleLabel?.font = UIFont(name: "Avenir-Next", size: 18)
        stopButton.layer.opacity = 0.5
        stopButton.layer.borderWidth = 1
        stopButton.layer.borderColor = UIColor.white.cgColor
        
        stopButton.addTarget(self, action: #selector(stop), for: .touchDown)
    }
    
    private func createCueLabel() {
        
    }
    
    // TODO: 
    private func createSectionLabel() {
        
    }
    
    private func setInitialValues() {
        setGraphicEqualizerInitialValues()
        setNanoKontrolInitialValues()
    }
    
    private func setGraphicEqualizerInitialValues() {
        graphicEqualizer["GAIN"].ramp(to: 1)
        graphicEqualizer["31.25"].ramp(to: 0.5)
        graphicEqualizer["16K"].ramp(to: 0.5)
    }
    
    private func setNanoKontrolInitialValues() {
        
        // Set bass to thoughtful level, to be increased in section 4
        nanoKontrol.channels[0].slider.ramp(to: 0.5)
        
        // Set sin/saw to barely present level
        nanoKontrol.channels[3].slider.ramp(to: 0.25)
        
        // Set sin/saw to saw
        nanoKontrol.channels[3].dial.ramp(to: 1)
    }
    
    private func constructTimeline() {
        addCircleProgressBarEvents()
        addGraphicEqualizerEvents()
        addNanoKontrolEvents()
        print("timeline: \(timeline)")
    }
    
    private func addCircleProgressBarEvents() {
        for (length, cumulative) in zip(lengths, lengths.cumulative) {
            timeline.add(at: cumulative) {
                self.animateCircle(duration: length)
            }
        }
    }
    
    // EQ EVENTS
    
    // TODO: Refine values, though this is a solid structure
    private func addGraphicEqualizerEvents() {
        rampEQ("31.25", to: 0.25, for: 0)
        rampEQ("16K", to: 0.25, for: 2)
        rampEQ("31.25", to: 0.5, for: 4)
        rampEQ("16K", to: 0.5, for: 6)
        rampEQ("31.25", to: 0.25, for: 8)
        rampEQ("16K", to: 0.25, for: 10)
        rampEQ("31.25", to: 0.5, for: 12)
        rampEQ("16K", to: 0.5, for: 14)
        rampEQ("31.25", to: 0.25, for: 16)
        rampEQ("16K", to: 0.25, for: 18)
        rampEQ("31.25", to: 0.5, for: 20)
        rampEQ("16K", to: 0.5, for: 22)
        rampEQ("31.25", to: 0.25, for: 24)
        
        // Then play trombone: d quartersharp
    }
    
    private func rampEQ(_ band: String, to value: Float, for event: Int) {
        timeline.add(at: lengths.cumulative[event]) {
            self.graphicEqualizer[band].ramp(to: value, over: self.lengths[event])
        }
    }
   
    private func add(for index: Int, action: @escaping () -> ()) {
        timeline.add(at: lengths.cumulative[index]) {
            action()
        }
    }
    
    // NANOKONTROL EVENTS
    
    private func addNanoKontrolEvents() {
        
        // SIN / SAW
        
        // Fade saw up to full volume over middle section
        rampNanoKontrolSlider(3, to: 1, over: 11..<21)
        // Fade saw down to quiet volume to last section
        rampNanoKontrolSlider(3, to: 0.25, over: 25..<29)
        // Crossfade saw -> sin
        rampNanoKontrolDial(3, to: 0, at: lengths.sum, over: 30)
        
        // add one more circle progress bar event for last section
        timeline.add(at: lengths.sum) {
            self.animateCircle(duration: 30)
        }
        
        // Quickly mute sin
        rampNanoKontrolSlider(3, to: 0, at: lengths.sum + 30, over: 0.125)
        
        // BASS
        
        // Fade to full over sections 2/3
        rampNanoKontrolSlider(0, to: 1, over: 3..<11)
        // Fade to 0.75 over 5th section
        rampNanoKontrolSlider(0, to: 0.75, over: 21..<25)
        
        // DISTANT
        
        // Fade to full over sections 2/3
        rampNanoKontrolSlider(1, to: 1, over: 3..<11)
        // Fade to none over section 5/6
        rampNanoKontrolSlider(1, to: 0, over: 21..<29)
        
        // FRONT
        
        // Fade to full within section 4
        rampNanoKontrolSlider(2, to: 1, over: 11..<18)
        
        // Fade out by end of section 5
        rampNanoKontrolSlider(2, to: 0, over: 18..<25)
        
        
        // STOP
        timeline.add(at: lengths.sum + 35) {
            self.stop()
        }
    }
    
    private func rampNanoKontrolDial(_ channel: Int, to value: Float, at offset: Double, over duration: Double) {
        timeline.add(at: offset) {
            self.nanoKontrol.channels[channel].dial.ramp(to: value, over: duration)
        }
    }
    
    private func rampNanoKontrolSlider(_ channel: Int, to value: Float, at offset: Double, over duration: Double) {
        timeline.add(at: offset) {
            self.nanoKontrol.channels[channel].slider.ramp(to: value, over: duration)
        }
    }
    
    private func rampNanoKontrolSlider(_ channel: Int, to value: Float, for event: Int) {
        timeline.add(at: lengths.cumulative[event]) {
            self.nanoKontrol.channels[channel].slider.ramp(to: value, over: self.lengths[event])
        }
    }
    
    private func rampNanoKontrolSlider(_ channel: Int, to value: Float, over events: Range<Int>) {
        timeline.add(at: lengths.cumulative[events.lowerBound]) {
            self.nanoKontrol.channels[channel].slider.ramp(
                to: value,
                over: self.lengths[events].sum
            )
        }
    }
    
    private func createNanoKontrol() {
        nanoKontrol?.removeFromSuperlayer()
        
        let width = rightWidth - 300
        let height = 1/2 * width
        
        self.nanoKontrol = NanoKontrolView(
            frame: CGRect(
                x: rightCenter - 0.5 * width,
                y: 200 - 0.5 * height,
                width: width,
                height: height
            )
        )
        view.layer.addSublayer(nanoKontrol)
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
    
    private func createGraphicEqualizer() {
        graphicEqualizer?.removeFromSuperlayer()
        let width = rightWidth - 200
        let height = 1/2 * width
        self.graphicEqualizer = GraphicEqualizerView(
            frame: CGRect(
                x: rightCenter - 0.5 * width,
                y: 800 - 0.5 * height,
                width: width,
                height: height
            )
        )
        view.layer.addSublayer(graphicEqualizer)
    }
    
    private func createCircleProgressBar() {
        
        circleLayer?.removeFromSuperlayer()
        
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
        circleLayer.strokeColor = UIColor.cyan.cgColor
        circleLayer.opacity = 0.5
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
