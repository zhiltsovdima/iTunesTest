//
//  Resources.swift
//  iTunesTest
//
//  Created by Dima Zhiltsov on 30.05.2023.
//

import UIKit

enum Resources {
    
    enum Colors {
        static let background = UIColor(named: "background")
        static let fontBW = UIColor(named: "fontBW")
        static let fontWB = UIColor(named: "fontWB")
        static let button = UIColor.systemBlue
        static let stopButton = UIColor.red
    }
    
    enum Identifiers {
        static let song = "SongCell"
    }
    
    enum Images {
        static let failedImage = UIImage(named: "FailedImage")
        static let play = UIImage(systemName: "play.fill")
        static let pause = UIImage(systemName: "pause.fill")
        static let stop = UIImage(systemName: "stop.fill")
        static let back = UIImage(systemName: "chevron.left")
    }
}
