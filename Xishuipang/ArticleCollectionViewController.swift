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

class ArticleCollectionViewController: UICollectionViewController, AllVolumeTableViewControllerDelegate, UICollectionViewDelegateFlowLayout {
    
    // MARK: outlets
    @IBOutlet weak var loadingProgress: UIProgressView!
    @IBOutlet weak var loadingLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    
    // MARK: constants
    let articleCollectionViewCellIdentifier = "ArticleCollectionViewCell"
    let articleCollectionHeaderIdentifier = "ArticleCollectionHeader"
    
    // MARK: properties
    var selectedVolume : Volume? = Volume()
    var settings : Settings? = Settings()
    
    // MARK: strings
    var strNoInternetTitle : String = ""
    var strNoInternetMessage : String = ""
    var strTableOfContent : String = ""
    var strLoading : String = ""
    
    // MARK: functions
    override func viewDidLoad() {
        super.viewDidLoad()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Do any additional setup after loading the view.
        /* if let savedVolume = getSavedVolumeFromDisk() {
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
        } */
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let settingsInstance = settings {
            if settingsInstance.characterVersion == .simplified {
                convertStrToSimplifiedCharacter()
            } else if settingsInstance.characterVersion == .traditional {
                convertStrToTraditionalCharacter()
            }
            updateViewWithNewStr()
        }
        
        if let volumeNumber = settings?.selectedVolumeNumber, let characterVersion = settings?.characterVersion, let volume = selectedVolume {
            if volume.volumeNumber != volumeNumber || volume.characterVersion != characterVersion {
                refreshContent(volumeNumber: volumeNumber, characterVersion: characterVersion)
            }
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
        if segue.identifier == "ShowAllVolumes" {
            guard let allVolumeViewController = segue.destination as? AllVolumeTableViewController else {
                os_log("Destination view controller is not AllVolumeTableViewController", log: .default, type: .debug)
                return
            }
            if let selectedVolumeNumber = settings?.selectedVolumeNumber {
                allVolumeViewController.selectedVolume = selectedVolumeNumber
            }
            allVolumeViewController.delegate = self
        } else if segue.identifier == "ShowArticle" {
            guard let articleViewController = segue.destination as? ArticleViewController else {
                fatalError("Destination of ShowArticle segue must be ArtcleViewController.")
            }
            guard let cell = sender as? ArticleCollectionViewCell else {
                fatalError("Sender is not a cell.")
            }
            articleViewController.settings = settings
            if let article = cell.article {
                articleViewController.article = article
            }
        } else if segue.identifier == "ShowSettings" {
            guard let settingsViewController = segue.destination as? SettingsTableViewController else {
                fatalError("Destination of ShowSettings segue must be SettingsTableViewController.")
            }
            
            settingsViewController.settings = settings
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
            cell.loadArticleToView()
        }
        
        return cell
    }
    
    override func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        
        guard let headerView = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: articleCollectionHeaderIdentifier, for: indexPath) as? ArticleCollectionHeader else {
            fatalError("The header instance is not a ArticleCollectionHeader.")
        }
        
        if let volume = selectedVolume {
            if volume.volumeNumber == 0 {
                headerView.setVolumeTitle(with: "")
                headerView.setThemeLabel(with: "")
            } else {
                if let characterVersion = settings?.characterVersion {
                    headerView.setVolumeTitlewithVolumeNumber(volume.volumeNumber, characterVersion: characterVersion)
                } else {
                    headerView.setVolumeTitlewithVolumeNumber(volume.volumeNumber, characterVersion: .simplified)
                }
                headerView.setThemeLabel(with: volume.volumeTheme)
            }
        }
        
        return headerView
    }
    
    // Uncomment this method to specify if the specified item should be highlighted during tracking
    override func collectionView(_ collectionView: UICollectionView, shouldHighlightItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // Uncomment this method to specify if the specified item should be selected
    override func collectionView(_ collectionView: UICollectionView, shouldSelectItemAt indexPath: IndexPath) -> Bool {
        return true
    }
    
    // MARK: AllVolumeTableViewControllerDelegate handler
    func allVolumeTableViewControllerWillDismiss(volumeNumber: Int) {
        if let settingsInstance = settings {
            settingsInstance.selectedVolumeNumber = volumeNumber
        }
        /*
        if let characterVersion = settings?.characterVersion {
            refreshContent(volumeNumber: volumeNumber, characterVersion: characterVersion)
        }*/
    }
    
    // MARK: private functions
    private func refreshContent(volumeNumber: Int, characterVersion: Settings.CharacterVersion) {
        selectedVolume?.clearVolumeContent()
        self.collectionView?.reloadData()
        resetLoadingLabelAndSpinner()
        loadingProgress?.setProgress(0.0, animated: true)
        let result = selectedVolume?.loadVolumeFromServer(withVolume: volumeNumber, characterVersion: characterVersion, progress: progressHandler, completion: volumeLoadedHandler, imageLoadedHandler: imageLoadedHandler)
        
        if result == false {
            let noInternetAlert = UIAlertController(title: strNoInternetTitle, message: strNoInternetMessage, preferredStyle: .alert)
            
            self.present(noInternetAlert, animated: true, completion: nil)
        }
    }
    
    private func hideLoadingLabelAndSpinner() {
        loadingLabel.isHidden = true
        loadingSpinner.stopAnimating()
    }
    
    private func resetLoadingLabelAndSpinner() {
        loadingLabel.text = strLoading;
        loadingLabel.isHidden = false
        loadingSpinner.startAnimating()
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
    
    private func convertStrToSimplifiedCharacter() {
        strTableOfContent = "目录"
        strLoading = "加载中..."
    }
    
    private func convertStrToTraditionalCharacter() {
        strTableOfContent = "目錄"
        strLoading = "加載中..."
    }
    
    private func updateViewWithNewStr() {
        navigationItem.title = strTableOfContent
    }
    
    // MARK: event handlers
    private func volumeLoadedHandler(isSuccessful:Bool, message:String) {
        if isSuccessful {
            self.collectionView?.reloadData()
            hideLoadingLabelAndSpinner()
        } else {
            loadingSpinner.stopAnimating()
            loadingLabel.text = message;
        }
    }
    
    private func progressHandler(progress: Float) {
        self.loadingProgress?.setProgress(progress, animated: true)
    }
    
    func imageLoadedHandler(_ articleIndex: Int) {
        var indices = [IndexPath]()
        let item = IndexPath(item: articleIndex, section: 0)
        if let _ = self.collectionView?.cellForItem(at: item) {
            indices.append(item)
            self.collectionView?.reloadItems(at: indices)
        }
    }
}
