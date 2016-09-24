//
//  CompoundControllerView.swift
//  CompoundControllerView
//
//  Created by James Bean on 9/18/16.
//
//

import QuartzCore
import GraphicsTools

public class CompoundControllerView: CALayer, CompositeShapeType {
    
    public var components: [CALayer] = []
    
    public init(frame: CGRect) {
        super.init()
        self.frame = frame
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func createComponents() {
        
    }
    
    public func makeFrame() -> CGRect {
        return CGRect.zero
    }
}
