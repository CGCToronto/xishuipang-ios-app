//
//  ImageExtension.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2019-01-05.
//  Copyright © 2019 Chinese Gospel Church. All rights reserved.
//

import UIKit

extension UIImage {
    func resizeWithAspectRatio(toFitIn newSize: CGSize) -> UIImage? {
        let heightWidthRatio = self.size.height/self.size.width
        var newSizeWithAspectRatio = CGSize()
        if newSize.width * heightWidthRatio > newSize.height {
            newSizeWithAspectRatio.height = newSize.height
            newSizeWithAspectRatio.width = newSize.height * (1 / heightWidthRatio)
        } else {
            newSizeWithAspectRatio.width = newSize.width
            newSizeWithAspectRatio.height = newSize.width * heightWidthRatio
        }
        UIGraphicsBeginImageContextWithOptions(newSizeWithAspectRatio, true, 0.0)
        self.draw(in: CGRect(x: 0, y: 0, width: newSizeWithAspectRatio.width, height: newSizeWithAspectRatio.height))
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return newImage
    }
}
