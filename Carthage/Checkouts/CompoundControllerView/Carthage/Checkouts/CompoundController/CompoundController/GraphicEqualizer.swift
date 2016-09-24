//
//  GraphicEqualizer.swift
//  CompoundController
//
//  Created by James Bean on 9/12/16.
//
//

public struct GraphicEqualizer {
    
    fileprivate var gain: Float = 0
    fileprivate var valueByBand: [Float: Float] = [:]
    
    // TODO: Manage gain
    // TODO: Use `Frequency` instead of `Float`
    // TODO: Use `fundamental` and multiples (f: 31.25, amountOfBands)
    // TODO: Manage + / - gains, not 0...1.0
    public init(bands: [Float]) {
        bands.forEach { valueByBand[$0] = 0.0 }
    }
    
    public init(fundamental: Float, amountBands: Int) {
        precondition(amountBands > 0)
        for partial in 1 ..< (amountBands + 1) {
            valueByBand[Float(partial) * fundamental] = 0.0
        }
    }
    
    // TODO: Change band type from `Float` to `Frequency`
    public subscript (band: Float) -> Float? {
        
        get {
            return valueByBand[band]
        }
        
        set {
            precondition(valueByBand[band] != nil)
            valueByBand[band] = newValue
        }
    }
}
