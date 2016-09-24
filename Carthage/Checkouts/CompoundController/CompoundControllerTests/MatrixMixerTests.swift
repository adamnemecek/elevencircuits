//
//  MatrixMixerTests.swift
//  CompoundController
//
//  Created by James Bean on 9/12/16.
//
//

import XCTest
@testable import CompoundController

class MatrixMixerTests: XCTestCase {
    
    func testInit() {
        let _ = MatrixMixer(4,4)
    }
    
    func testInitDefaultZeros() {
        let amountInputs = 2
        let amountOutputs = 3
        let matrixMixer = MatrixMixer(amountInputs, amountOutputs)
        for i in 0 ..< amountInputs {
            for o in 0 ..< amountOutputs {
                XCTAssertEqual(matrixMixer[i,o], 0.0)
            }
        }
    }
    
    func testSubscript() {
        var matrixMixer = MatrixMixer(2,3)
        matrixMixer[0,1] = 0.5
        XCTAssertEqual(matrixMixer[0,1], 0.5)
    }
    
    func testCopy() {
        var a = MatrixMixer(4,4)
        a[2,2] = 1.0
        let b = a
        XCTAssertEqual(b[2,2], 1.0)
    }
}
