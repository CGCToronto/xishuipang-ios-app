//
//  Volume.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-06.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import Foundation
import os.log

class Volume : NSObject {

    // MARK: properties
    var volumeNumber: Int = 0
    var publishYear: Int = 2000
    var publishMonth: Int = 1
    var publishDay: Int = 1
    var volumeTheme: String = ""
    var articles = [Article]()
    
    // MARK: state variables
    var readFromServerResult = false
    var numLoadedArticles = 0
    
    // MARK: URLSession
    private let defaultSession = URLSession(configuration: .default)
    private var dataTask : URLSessionTask?
    
    override init() {
        super.init()
    }
    
    // MARK: Implementation
    func loadVolumeFromServer(withVolume volume:Int, progress: @escaping (Float) -> Void, completion: @escaping ()->Void) -> Bool {
        readFromServerResult = false
        if var urlComponents = URLComponents(string: API.ArticleList.URL) {
            dataTask?.cancel()
            urlComponents.query = API.ArticleList.Query(volume: volume, character: "simplified")
            
            guard let url = urlComponents.url else {
                return false
            }

            let handler = { (data: Data?, response:URLResponse?, error:Error?) -> Void in
                if let error = error {
                    os_log("Error: %S", log: .default, type: .debug, error.localizedDescription)
                    self.readFromServerResult = false
                } else if let data = data, let response = response as? HTTPURLResponse, response.statusCode == 200 {
                    let articleLoadedHandler = {
                        self.numLoadedArticles = self.numLoadedArticles + 1
                        let progressPercentage = Float(self.numLoadedArticles) / Float(self.articles.count)
                        if progressPercentage < 1.0 {
                            DispatchQueue.main.async {
                                progress(progressPercentage)
                            }
                        } else {
                            DispatchQueue.main.async {
                                progress(progressPercentage)
                                completion()
                            }
                        }
                    }
                    self.numLoadedArticles = 0
                    if self.parse(data:data, articleLoadedHandler:articleLoadedHandler) {
                        self.readFromServerResult = true
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
    
    // MARK: parsing
    func parse(data: Data?, articleLoadedHandler: @escaping () -> Void) -> Bool {
        do {
            guard let data = data else {
                return false
            }
            guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
                throw NSError()
            }
            if let jsonDictionary = jsonObj as? [String:Any] {
                return parse(volume:jsonDictionary, articleLoadedHandler:articleLoadedHandler)
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }
        
        return true
    }
    
    fileprivate func parse(volume: [String:Any], articleLoadedHandler: @escaping () -> Void) -> Bool {
        if let volumeNumberStr = volume["volume"] as? String,
            let volumeNumber = Int(volumeNumberStr),
            let categories = volume["table_of_content"] as? [Any] {
            self.volumeNumber = volumeNumber
            var result = true
            for category in categories {
                if let categoryDictionary = category as? [String:Any] {
                    result = result && parse(category:categoryDictionary, articleLoadedHandler:articleLoadedHandler)
                } else {
                    return false
                }
            }
            return result
        } else {
            return false
        }
    }
    
    fileprivate func parse(category: [String:Any], articleLoadedHandler: @escaping () -> Void) -> Bool {
        if let categoryName = category["category"] as? String,
            let articleCollection = category["articles"] as? [Any] {
            var result = true
            for article in articleCollection {
                if let articleDictionary = article as? [String:Any]{
                    result = result && parse(article:articleDictionary, category: categoryName, articleLoadedHandler:articleLoadedHandler)
                } else {
                    return false
                }
            }
            return result
        } else {
            return false
        }
    }
    
    fileprivate func parse(article: [String:Any], category: String, articleLoadedHandler: @escaping () -> Void) -> Bool {
        if let title = article["title"] as? String,
            let author = article["author"] as? String,
            let id = article["id"] as? String {
            let newArticle = Article(volume: volumeNumber, id: id, title: title, category: category, author: author)
            if newArticle.loadArticleContentFromServer(completionHandler: articleLoadedHandler) {
                articles.append(newArticle)
            }
            return true
        } else {
            return false
        }
    }
}
