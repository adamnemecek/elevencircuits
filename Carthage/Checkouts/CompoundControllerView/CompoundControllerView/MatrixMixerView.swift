//
//  MatrixMixerView.swift
//  CompoundControllerView
//
//  Created by James Bean on 9/18/16.
//
//

// TODO: Inject LayoutTools
import ArrayTools
import QuartzCore
import Color
import CompoundController
import ControllerElements

extension Dial: EmptyInitializable { }

public class MatrixMixerView: CompoundControllerView {
    
    private let amountInputs: UInt
    private let amountOutputs: UInt
    
    private var dials: Matrix<Dial>
    
    public init(frame: CGRect, amountInputs: UInt, amountOutputs: UInt) {
        self.amountInputs = amountInputs
        self.amountOutputs = amountOutputs
        self.dials = Matrix<Dial>(amountRows: amountOutputs, amountColumns: amountInputs)
        super.init(frame: frame)
        createDials()
        borderWidth = 1
        borderColor = Color(gray: 0, alpha: 1).cgColor
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public subscript (input: UInt, output: UInt) -> Dial {
        
        get {
            return dials[input, output]
        }
        
        set {
            dials[input, output] = newValue
        }
    }
    
    private func createDials() {
        let width = frame.width / CGFloat(amountOutputs)
        let height = frame.height / CGFloat(amountInputs)
        let size = CGSize(width: width, height: height)
        for o in 0 ..< amountOutputs {
            let left = CGFloat(o) / CGFloat(amountOutputs) * frame.width
            for i in 0 ..< amountInputs {
                let top = CGFloat(i) / CGFloat(amountInputs) * frame.height
                let origin = CGPoint(x: left, y: top)
                let dialFrame = CGRect(origin: origin, size: size)
                let dial = Dial(frame: dialFrame)
                dials[i,o] = dial
                addSublayer(dial)
            }
        }
    }
}
