//
//  Settings.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-01-28.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import Foundation

class Settings : NSObject {
    enum CharacterVersion {
        case simplified, traditional
    }
    var characterVersion : CharacterVersion = .simplified
    var fontSize : Int = 20
    var selectedVolumeNumber : Int = 57
}
