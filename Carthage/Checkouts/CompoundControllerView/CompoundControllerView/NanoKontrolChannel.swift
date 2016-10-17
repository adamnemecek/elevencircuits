//
//  NanoKontrolChannel.swift
//  CompoundControllerView
//
//  Created by James Bean on 10/16/16.
//
//

import ControllerElements
import QuartzCore

public class NanoKontrolChannel: CompoundControllerView {
    
    public var slider: Slider!
    public var dial: Dial!
    
    public init(frame: CGRect, label: String = "") {
        super.init(frame: frame)
        
        let dialHeight = 0.1 * frame.height
        let padding = 0.5 * dialHeight
        let sliderHeight = frame.height - dialHeight - padding
        let sliderWidth = 0.75 * frame.width
        
        self.dial = Dial(
            frame: CGRect(
                x: 0.5 * frame.width - 0.5 * dialHeight,
                y: 0,
                width: dialHeight,
                height: dialHeight
            ),
            operatingInterval: (0.1, 0.9)
        )
        
        self.slider = Slider(
            frame: CGRect(
                x: 0.5 * (frame.width - sliderWidth),
                y: dialHeight + padding,
                width: sliderWidth,
                height: sliderHeight
            ),
            label: label
        )
        
        addSublayer(slider)
        addSublayer(dial)
    }
    
    public required init?(coder aDecorder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
