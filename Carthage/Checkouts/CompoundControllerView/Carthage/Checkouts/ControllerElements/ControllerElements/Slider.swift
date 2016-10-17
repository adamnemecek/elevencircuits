//
//  Slider.swift
//  ControllerElements
//
//  Created by James Bean on 9/17/16.
//
//

#if os(iOS)
    import UIKit
#elseif os(OSX)
    import AppKit
#endif

import QuartzCore
import Color
import PathTools
import GraphicsTools

public class Slider: CALayer, CompositeShapeType {
    
    private let layer = CALayer()
    
    public var components: [CALayer] = []
    
    fileprivate var indicator: CALayer!
    
    fileprivate var indicatorHeight: CGFloat { return 0.0382 * slotHeight }
    
    public var label: String = ""
    
    public var slotHeight: CGFloat { return frame.height - labelHeight }
    private var labelHeight: CGFloat { return 0.1 * frame.height }
    
    public var value: Float = 0.0 {
        
        didSet {
            guard value >= 0.0 && value <= 1.0 else { return }
            updateIndicatorPosition(value: value)
        }
    }
    
    public required override init() {
        super.init()
    }
    
    public init(frame: CGRect, label: String = "") {
        super.init()
        self.frame = frame
        self.label = label
        createComponents()
        updateIndicatorPosition(value: value)
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createComponents() {
        createSlot()
        createIndicator()
        createLabel()
        addSublayer(layer)
    }
    
    private func createSlot() {
        let slotWidth = 0.382 * frame.width
        let left = 0.5 * (frame.width - slotWidth)
        let rect = Path.rectangle(rectangle: CGRect(x: left, y: 0, width: slotWidth, height: slotHeight))
        let rectLayer = CAShapeLayer()
        rectLayer.path = rect.cgPath
        rectLayer.lineWidth = 1
        rectLayer.strokeColor = Color(gray: 0.5, alpha: 1).cgColor
        rectLayer.fillColor = Color(gray: 0, alpha: 1).cgColor
        layer.addSublayer(rectLayer)
    }
    
    private func createIndicator() {
        let width = 0.75 * frame.width
        let path = Path.rectangle(
            rectangle: CGRect(
                x: 0.5 * (frame.width - width),
                y: 0,
                width: width,
                height: indicatorHeight
            )
        )
        let shape = CAShapeLayer()
        shape.path = path.cgPath
        shape.fillColor = Color.red.cgColor
        layer.addSublayer(shape)
        indicator = shape
    }
    
    private func createLabel() {
        
        // TODO: Inject dn-m/TextLayer when it is reimplemented
        let labelLayer = CATextLayer()
        labelLayer.string = label
        
        // FIXME: Set as function of frame.height
        labelLayer.fontSize = 15
        labelLayer.foregroundColor = Color(gray: 0.5, alpha: 1).cgColor
        labelLayer.font = CGFont("Helvetica" as CFString)
        labelLayer.frame = CGRect(x: 0, y: slotHeight + 5, width: frame.width, height: labelHeight)
        labelLayer.alignmentMode = kCAAlignmentCenter
        
        #if os(iOS)
            labelLayer.contentsScale = UIScreen.main.scale
        #elseif os(OSX)
            labelLayer.contentsScale = NSScreen.main.scale
        #endif
        
        addSublayer(labelLayer)
    }
    
    // TODO: Consider making this completely instance-level state, or completely local- !
    private func updateIndicatorPosition(value: Float) {
        CATransaction.setDisableActions(true)
        indicator.frame.origin.y = altitude(from: value) - 0.5 * indicatorHeight
        CATransaction.setDisableActions(false)
    }

    public func makeFrame() -> CGRect {
        return CGRect.zero
    }
    
    fileprivate func altitude(from value: Float) -> CGFloat {
        return CGFloat(1 - value) * slotHeight
    }
}

extension Slider: ContinuousController {
    
    public func ramp(to newValue: Float, over duration: Double = 0) {
        
        let animation = CABasicAnimation(keyPath: "position.y")
        animation.duration = duration
        animation.timingFunction = CAMediaTimingFunction(name: kCAMediaTimingFunctionEaseInEaseOut)
        animation.fromValue = altitude(from: value) - 0.5 * indicatorHeight
        animation.toValue = altitude(from: newValue) - 0.5 * indicatorHeight
        animation.fillMode = kCAFillModeForwards
        animation.isRemovedOnCompletion = false
        
        indicator.add(animation, forKey: "position.y")
        
        // update instance-level property `value`
        self.value = newValue
    }
}
