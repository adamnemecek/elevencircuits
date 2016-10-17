//
//  NanoKontrolView.swift
//  CompoundControllerView
//
//  Created by James Bean on 10/16/16.
//
//

import QuartzCore
import PathTools
import Color

// TODO: Break up into MasterSection and ChannelsSection
public class NanoKontrolView: CompoundControllerView {
    
    // TODO: make dictionary of channels by index
    public var channels: [NanoKontrolChannel] = []
    
    private var masterSectionWidth: CGFloat {
        return 0.125 * frame.width - 0.5 * sectionPadding
    }
    
    private var channelsSectionWidth: CGFloat {
        return frame.width - masterSectionWidth - 0.5 * sectionPadding
    }
    
    private var sectionPadding: CGFloat {
        return 0.1 * frame.width
    }
    
    // TODO: add 8 channels and master
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createChannelsSection()
        createMasterSection()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createMasterSection() {
        createStartButton()
        createStopButton()
    }
    
    // FIXME: Encapsulate logic into Button API
    private func createStartButton() {
        
        let buttonWidth: CGFloat = 30
        let padding: CGFloat = 0.25 * buttonWidth
        
        // Encapsulate into own class
        let button = CALayer()
        button.frame = CGRect(
            x: buttonWidth + padding,
            y: 0.75 * frame.height - buttonWidth,
            width: buttonWidth,
            height: buttonWidth
        )
        
        button.borderColor = Color(gray: 0.5, alpha: 0.5).cgColor
        button.borderWidth = 1
        let triangleLayer = CAShapeLayer()
        
        // TODO: Update Path.triangle API
        let trianglePath = Path()
            .move(to: CGPoint(x: 0, y: 0))
            .addLine(to: CGPoint(x: button.frame.width, y: 0.5 * button.frame.height))
            .addLine(to: CGPoint(x: 0, y: button.frame.height))
            .scaled(by: 0.618)
            .translated(
                horizontallyBy: 0.618 * 0.382 * button.frame.width,
                verticallyBy: 0.5 * 0.382 * button.frame.width
            )
        triangleLayer.path = trianglePath.cgPath
        triangleLayer.fillColor = Color(gray: 0.5, alpha: 1).cgColor
        button.addSublayer(triangleLayer)
        addSublayer(button)
    }
    
    private func createStopButton() {
        
        let buttonWidth: CGFloat = 30
        
        let button = CALayer()
        button.frame = CGRect(
            x: 0,
            y: 0.75 * frame.height - buttonWidth,
            width: buttonWidth,
            height: buttonWidth
        )
        button.borderColor = Color(gray: 0.5, alpha: 0.5).cgColor
        button.borderWidth = 1
        
        let squareLayer = CAShapeLayer()
        let squarePath = Path.square(
            center: CGPoint(x: 0.5 * button.frame.width, y: 0.5 * button.frame.height),
            width: 0.5 * button.frame.width
        )
        squareLayer.path = squarePath.cgPath
        squareLayer.fillColor = Color(gray: 0.5, alpha: 1).cgColor
        button.addSublayer(squareLayer)
        
        addSublayer(button)
    }
    
    private func createChannelsSection() {
        var accumLeft: CGFloat = masterSectionWidth + sectionPadding
        for i in 0 ..< 8 {
            let width = frame.width / 8
            let channel = NanoKontrolChannel(
                frame: CGRect(x: accumLeft, y: 0, width: width, height: frame.height)
            )
            channels.append(channel)
            addSublayer(channel)
            accumLeft += width
        }
    }
}
