//
//  ArticleCollectionViewController.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-10.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import UIKit
import os.log

private let reuseIdentifier = "Cell"

class ArticleCollectionViewController: UICollectionViewController, AllVolumeTableViewControllerDelegate {
    
    // MARK: constants
    let articleCollectionViewCellIdentifier = "ArticleCollectionViewCell"
    
    // MARK: properties
    var selectedVolume : Volume?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        if let savedVolume = getSavedVolumeFromDisk() {
            selectedVolume = savedVolume
        } else if let latestVolume = getLatestVolumeFromServer() {
            selectedVolume = latestVolume
        } else {
            selectedVolume = Volume()
            var articles = [Article]()
            articles.append(Article())
            articles.append(Article())
            articles.append(Article())
            articles.append(Article())
            selectedVolume?.articles = articles
            
            os_log("App is offline", log: .default, type: .debug)
        }
    }
    
    private func getSavedVolumeFromDisk() -> Volume? {
        // load the opened volume from the user in this function.
        // to be implemented
        return nil
    }
    
    private func getLatestVolumeFromServer() -> Volume? {
        // return the latest volume from server in this function.
        // to be implemented
        return nil
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAllVolume" {
            guard let allVolumeViewController = segue.destination as? AllVolumeTableViewController else {
                os_log("Destination view controller is not AllVolumeTableViewController", log: .default, type: .debug)
                return
            }
            allVolumeViewController.delegate = self
        } else if segue.identifier == "ShowArticle" {
            guard let articleViewController = segue.destination as? ArticleViewController else {
                fatalError("Destination of ShowArticle segue must be ArtcleViewController.")
            }
            guard let cell = sender as? ArticleCollectionViewCell else {
                fatalError("Sender is not a cell.")
            }
            
            if let article = cell.article {
                articleViewController.article = article
            }
        }
    }
 

    // MARK: UICollectionViewDataSource

    override func numberOfSections(in collectionView: UICollectionView) -> Int {
        // #warning Incomplete implementation, return the number of sections
        return 1
    }


    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let articles = selectedVolume?.articles {
            return articles.count
        }
        else {
            return 0
        }
    }

    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        guard let cell = collectionView.dequeueReusableCell(withReuseIdentifier: articleCollectionViewCellIdentifier, for: indexPath) as? ArticleCollectionViewCell else {
            fatalError("The cell instance is not a ArticleCollectionViewCell.")
        }

        if let articles = selectedVolume?.articles {
            cell.article = articles[indexPath.row]
            cell.layer.cornerRadius = 12
            cell.layer.masksToBounds = false
            cell.layer.shadowColor = UIColor.gray.cgColor
            cell.layer.shadowOffset = CGSize(width:0, height: 0.5)
            cell.layer.shadowOpacity = 0.5
            cell.layer.shadowRadius = 5
            let path = CGPath(rect: cell.bounds, transform: nil)
            cell.layer.shadowPath = path
            cell.loadArticleToView()
        }
        
        return cell
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    /*
    public func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize
    {
    }
 */

    // MARK: UICollectionViewDelegate

    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    

    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }

    /*
    // Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
    override func collectionView(_ collectionView: UICollectionView, shouldShowMenuForItemAt indexPath: IndexPath) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, canPerformAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) -> Bool {
        return false
    }

    override func collectionView(_ collectionView: UICollectionView, performAction action: Selector, forItemAt indexPath: IndexPath, withSender sender: Any?) {
    
    }
    */
    
    // MARK: AllVolumeTableViewControllerDelegate handler
    func allVolumeTableViewControllerWillDismiss(volume: Volume) {
        selectedVolume = volume
    }
}
