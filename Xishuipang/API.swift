//
//  Constant.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-29.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import Foundation

struct API {
    struct ArticleList {
        static let URL = "http://www.xishuipang.com/article/list"
        static func Query(volume: Int, character: String) -> String {
            return "volume=\(volume)&character=\(character)"
        }
    }
    
    struct Article {
        static let URL = "http://www.xishuipang.com/article/get"
        static func Query(volume: Int, id: String, character: String) -> String {
            return "volume=\(volume)&name=\(id)&character=\(character)"
        }
    }
    
    struct Image {
        static let URL = "http://www.xishuipang.com/content"
        static func Query(volume: Int, imageFileName: String) -> String {
            return "volume_\(volume)/images/\(imageFileName)"
        }
    }
}