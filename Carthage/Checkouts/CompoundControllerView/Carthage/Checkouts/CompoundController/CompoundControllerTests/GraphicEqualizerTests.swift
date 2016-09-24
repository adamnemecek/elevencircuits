//
//  GraphicEqualizerTests.swift
//  CompoundController
//
//  Created by James Bean on 9/12/16.
//
//

import XCTest
@testable import CompoundController

class GraphicEqualizerTests: XCTestCase {
    
    func testInitWithBands() {
        let bands: [Float] = [31.25, 62.5, 125, 250, 500, 1000, 2000, 4000, 8000, 16000]
        let eq = GraphicEqualizer(bands: bands)
        for band in bands { XCTAssertEqual(eq[band], 0.0) }
    }
    
    func testSubscript() {
        var eq = GraphicEqualizer(fundamental: 31.25, amountBands: 10)
        eq[62.5] = 1.0
        XCTAssertEqual(eq[62.5], 1.0)
    }
}
