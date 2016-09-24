//
//  GraphicEqualizerView.swift
//  CompoundControllerView
//
//  Created by James Bean on 9/20/16.
//
//

import QuartzCore
import Color
import CompoundController
import ControllerElements

public class GraphicEqualizerView: CompoundControllerView {
    
    private let amountBands: UInt
    
    private var sliders: [Slider] = []
    
    public init(frame: CGRect, amountBands: UInt) {
        self.amountBands = amountBands
        super.init(frame: frame)
        createSliders()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public subscript (slider: UInt) -> Slider {
        
        get {
            return sliders[Int(slider)]
        }
        
        set {
            sliders[Int(slider)] = newValue
        }
    }
    
    private func createSliders() {
        let width = frame.width / CGFloat(amountBands)
        
        self.sliders = (0 ..< amountBands).map { i in
            let left = frame.width * (CGFloat(i) / CGFloat(amountBands))
            let origin = CGPoint(x: left, y: 0)
            let size = CGSize(width: width, height: frame.height)
            let slider = Slider(frame: CGRect(origin: origin, size: size))
            addSublayer(slider)
            return slider
        }
    }
    
    private func layoutSliders() {
        // TODO
    }
}
