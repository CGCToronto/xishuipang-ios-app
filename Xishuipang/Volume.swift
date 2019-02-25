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
    var characterVersion: Settings.CharacterVersion = .simplified
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
    
    // MARK: Operations
    func clearVolumeContent() {
        volumeNumber = 0
        characterVersion = .simplified
        publishYear = 2000
        publishMonth = 1
        publishDay = 1
        volumeTheme = ""
        articles.removeAll()
    }
    
    func loadVolumeFromServer(withVolume volume:Int, characterVersion: Settings.CharacterVersion, progress: @escaping (Float) -> Void, completion: @escaping (Bool,String)->Void, imageLoadedHandler: @escaping (_ indexInVolume: Int)->Void) -> Bool {
        readFromServerResult = false
        if var urlComponents = URLComponents(string: API.ArticleList.URL) {
            dataTask?.cancel()
            var character = "simplified"
            if characterVersion == .traditional {
                character = "traditional"
            }
            self.characterVersion = characterVersion
            urlComponents.query = API.ArticleList.Query(volume: volume, character: character)
            
            guard let url = urlComponents.url else {
                return false
            }

            let handler = { (data: Data?, response:URLResponse?, error:Error?) -> Void in
                if let error = error {
                    os_log("Error: %S", log: .default, type: .debug, error.localizedDescription)
                    self.readFromServerResult = false
                    DispatchQueue.main.async {
                        completion(false, "网络有误，请确保您的设备连接无线网络。");
                    }
                } else if let response = response as? HTTPURLResponse {
                    if response.statusCode == 200 {
                        if let data = data {
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
                                        completion(true, "")
                                    }
                                }
                            }
                            self.numLoadedArticles = 0
                            if self.parse(data:data, articleLoadedHandler, imageLoadedHandler) {
                                self.readFromServerResult = true
                            } else {
                                DispatchQueue.main.async {
                                    completion(false, "本期繁體版本還未上傳，敬請諒解。");
                                }
                            }
                        }
                    } else if response.statusCode == 404 {
                        DispatchQueue.main.async {
                            completion(false, "无法找到页面。");
                        }
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
    
    // MARK: Implementation
    fileprivate func parse(data: Data?,
                           _ articleLoadedHandler: @escaping () -> Void,
                           _ imageLoadedHandler: @escaping (_ indexInVolume: Int) -> Void) -> Bool {
        do {
            guard let data = data else {
                return false
            }
            guard let jsonObj = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? NSDictionary else {
                throw NSError()
            }
            if let jsonDictionary = jsonObj as? [String:Any] {
                return parse(volume:jsonDictionary, articleLoadedHandler, imageLoadedHandler)
            }
            
        } catch let error as NSError {
            print(error.debugDescription)
            return false
        }
        
        return true
    }
    
    fileprivate func parse(volume: [String:Any],
                           _ articleLoadedHandler: @escaping () -> Void,
                           _ imageLoadedHandler: @escaping (_ indexInVolume: Int) -> Void) -> Bool {
        if let volumeNumberStr = volume["volume"] as? String,
            let volumeNumber = Int(volumeNumberStr),
            let categories = volume["table_of_content"] as? [Any] {
            if let theme = volume["theme"] as? String {
                self.volumeTheme = theme
            }
            self.volumeNumber = volumeNumber
            var result = true
            for category in categories {
                if let categoryDictionary = category as? [String:Any] {
                    result = result && parse(category:categoryDictionary, articleLoadedHandler, imageLoadedHandler)
                } else {
                    return false
                }
            }
            return result
        } else {
            return false
        }
    }
    
    fileprivate func parse(category: [String:Any],
                           _ articleLoadedHandler: @escaping () -> Void,
                           _ imageLoadedHandler: @escaping (_ indexInVolume: Int) -> Void) -> Bool {
        if let categoryName = category["category"] as? String,
            let articleCollection = category["articles"] as? [Any] {
            var result = true
            for article in articleCollection {
                if let articleDictionary = article as? [String:Any]{
                    result = result && parse(article:articleDictionary, category: categoryName, articleLoadedHandler, imageLoadedHandler)
                } else {
                    return false
                }
            }
            return result
        } else {
            return false
        }
    }
    
    fileprivate func parse(article: [String:Any],
                           category: String,
                           _ articleLoadedHandler: @escaping () -> Void,
                           _ imageLoadedHandler: @escaping (_ indexInVolume: Int) -> Void) -> Bool {
        if let title = article["title"] as? String,
            let author = article["author"] as? String,
            let id = article["id"] as? String {
            let newArticle = Article(volume: volumeNumber, characterVersion: characterVersion, id: id, title: title, category: category, author: author)
            let indexInVolume = articles.count
            if newArticle.loadArticleContentFromServer(indexInVolume: indexInVolume, completionHandler: articleLoadedHandler, imageLoadedHandler: imageLoadedHandler) {
                articles.append(newArticle)
            }
            return true
        } else {
            return false
        }
    }
}
