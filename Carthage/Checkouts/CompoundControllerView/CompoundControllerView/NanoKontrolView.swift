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
 
    private var channelsSectionWidth: CGFloat {
        return frame.width
    }
    
    private var sectionPadding: CGFloat {
        return 0.0 * frame.width
    }
    
    // TODO: add 8 channels and master
    public override init(frame: CGRect) {
        super.init(frame: frame)
        createChannelsSection()
    }
    
    public required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func createChannelsSection() {
        var accumLeft: CGFloat = 0
        for i in 0 ..< 8 {
            let width = frame.width / 8
            let channel = NanoKontrolChannel(
                frame: CGRect(x: accumLeft, y: 0, width: width, height: frame.height),
                label: "\(i + 1)"
            )
            channels.append(channel)
            addSublayer(channel)
            accumLeft += width
        }
    }
}
