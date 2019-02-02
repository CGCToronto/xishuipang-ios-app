//
//  ArticleCollectionHeader.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-01-27.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import UIKit

class ArticleCollectionHeader: UICollectionReusableView {
    @IBOutlet weak var volumeLabel: UILabel!
    @IBOutlet weak var themeLabel: UILabel!
    
    func setVolumeTitlewithVolumeNumber(_ volume:Int, characterVersion: Settings.CharacterVersion) {
        volumeLabel.text = "溪水旁第\(volume)期"
    }
    
    func setVolumeTitle(with title: String) {
        volumeLabel.text = title
    }
    
    func setThemeLabel(with theme: String) {
        themeLabel.text = theme
    }
}
