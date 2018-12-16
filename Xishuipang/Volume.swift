//
//  Volume.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-06.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import Foundation

class Volume : NSObject {

    // MARK: properties
    var volumeNumber: Int = 0
    var publishYear: Int = 2000
    var publishMonth: Int = 1
    var publishDay: Int = 1
    var volumeTheme: String = ""
    var articles : [Article]?
    
    override init() {
        super.init()
    }
}
