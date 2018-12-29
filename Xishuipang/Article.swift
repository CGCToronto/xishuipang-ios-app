//
//  Article.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-06.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import Foundation
import os.log

class Article : NSObject {
    
    // MARK: properties
    var volume = 0
    var id = ""
    var title = ""
    var category = ""
    var author = ""
    var imagesPaths = [String]()
    var content = [String]()
    
    // MARK: URLSession
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask : URLSessionTask?
    
    // MARK: constructors
    override init()
    {
        super.init()
    }
    
    convenience init(volume: Int, id: String, title: String, category: String, author: String) {
        self.init()
        self.volume = volume
        self.id = id
        self.title = title
        self.category = category
        self.author = author
    }
    
    func loadArticleContentFromServer(completionHandler: @escaping ()->Void) -> Bool {
        if var urlComponents = URLComponents(string: API.Article.URL) {
            dataTask?.cancel()
            urlComponents.query = API.Article.Query(volume: volume, id: id, character: "simplified")
        
            guard let url = urlComponents.url else {
                return false
            }
            
            let handler = { (data: Data?, response:URLResponse?, error:Error?) -> Void in
                if let error = error {
                    os_log("Error: %S", log: .default, type: .debug, error.localizedDescription)
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    if self.parse(data:data) {
                        completionHandler()
                    }
                }
                
                self.dataTask = nil
            }
            
            dataTask = defaultSession.dataTask(with: url, completionHandler: handler)
            dataTask?.resume()
            return true
        } else {
            return false
        }
    }
    
    fileprivate func parse(data: Data?) -> Bool {
        do {
            guard let data = data else {
                return false
            }
            guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
                throw NSError()
            }
            if let jsonDictionary = jsonObj as? [String:Any] {
                return parse(article:jsonDictionary)
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }
        
        return true
    }
    
    fileprivate func parse(article: [String: Any]) -> Bool {
        if let contentArray = article["content"] as? [Any] {
            for sentence in contentArray {
                if let sentenceStr = sentence as? String {
                    content.append(sentenceStr)
                } else {
                    return false
                }
            }
            return true
        } else {
            return false
        }
    }
}
