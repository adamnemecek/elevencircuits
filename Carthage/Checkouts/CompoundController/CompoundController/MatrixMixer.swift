//
//  MatrixMixer.swift
//  CompoundController
//
//  Created by James Bean on 9/12/16.
//
//

import ArrayTools

public struct MatrixMixer {
    
    fileprivate var matrix: Matrix<Float>
    
    public init(_ amountInputs: UInt, _ amountOutputs: UInt) {
        self.matrix = Matrix(amountRows: amountInputs, amountColumns: amountOutputs)
    }
    
    public subscript(input: UInt, output: UInt) -> Float {
        
        get {
            return matrix[input, output]
        }
        
        set {
            matrix[input, output] = newValue
        }
    }
}
