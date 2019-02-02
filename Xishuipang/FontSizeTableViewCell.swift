//
//  FontSizeTableViewCell.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-02-01.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import UIKit

class FontSizeTableViewCell: UITableViewCell {

    // MARK: Properties
    @IBInspectable var fontSize: Int = 20 // Default Value
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
