//
//  ArticleViewController.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-08.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import UIKit

class ArticleViewController: UIViewController {

    // MARK: outlets
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var loadingSpinner: UIActivityIndicatorView!
    @IBOutlet weak var contentStackView: UIStackView!
    
    // MARK: properties
    var article : Article?
    var settings : Settings?
    var fontSize : Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadingSpinner.center = CGPoint(x: view.frame.width / 2.0, y: view.frame.height / 2.0)
        loadingSpinner.startAnimating()
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let article = article, let settings = settings {
            if article.characterVersion != settings.characterVersion {
                article.changeArticleCharacterVersion(settings.characterVersion)
                // Change article id here to properly get the correct article.
                let completionHandler = {
                    DispatchQueue.main.async {
                        self.loadArticleContentToView()
                    }
                }
                
                let imageLoadedHandler = {
                    (_ indexInVolume: Int) -> Void in
                }
                
                article.loadArticleContentFromServer(indexInVolume: 0, completionHandler: completionHandler, imageLoadedHandler: imageLoadedHandler)
            } else {
                loadArticleContentToView()
            }
        }
        loadingSpinner.stopAnimating()
    }
    
    // MARK: private methods
    func loadArticleContentToView() {
        clearContentStack()
        if let article = article {
            
            if let settings = settings {
                fontSize = settings.fontSize
            }
            let font = UIFont.preferredFont(forTextStyle: .body).withSize(CGFloat(fontSize))
            
            categoryLabel.text = article.category
            titleLabel.text = article.title
            authorLabel.text = article.author
            
            categoryLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(CGFloat(fontSize))
            titleLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(CGFloat(fontSize + 5))
            authorLabel.font = UIFont.preferredFont(forTextStyle: .largeTitle).withSize(CGFloat(fontSize - 5))
            
            for line in article.content {
                if article.isImageTag(line: line) {
                    
                    let viewWidth = view.frame.width
                    let stackViewWidth = contentStackView.frame.width
                    
                    let imageFileName = article.getImageFilenameFromImageTag(line: line)
                    let imageInfo = article.images[imageFileName]
                    if imageInfo == nil || imageInfo?.imageData == nil {
                        continue
                    }
                    
                    let resizedImage = imageInfo?.imageData?.resizeWithAspectRatio(toFitIn: CGSize(width:stackViewWidth, height:stackViewWidth))
                    let imageView = UIImageView(image: resizedImage)
                    imageView.contentMode = .scaleAspectFit
                    contentStackView.addArrangedSubview(imageView)
                    
                    if imageInfo?.caption != "" {
                        let captionText: String = imageInfo!.caption
                        let captionView = createLineTextView(text: captionText, alignment: .center, fontSize: fontSize - 3)
                        contentStackView.addArrangedSubview(captionView)
                    }
                    
                } else if !article.isEmpty(line: line) {
                    let lineTextView = createLineTextView(text: line, alignment: .left, fontSize: fontSize)
                    contentStackView.addArrangedSubview(lineTextView)
                }
            }
        }
    }
    
    private func createLineTextView(text: String, alignment: NSTextAlignment, fontSize: Int)
        -> UITextView {
        let lineTextView = UITextView()
        lineTextView.isScrollEnabled = false
        lineTextView.isEditable = false
        let font = UIFont.preferredFont(forTextStyle: .body).withSize(CGFloat(fontSize))
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = 8
        paragraphStyle.alignment = alignment
        let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: font]
        lineTextView.attributedText = NSAttributedString(string: text, attributes: attributes)
        return lineTextView
    }
    
    private func clearContentStack() {
        let arrangedViews = contentStackView.arrangedSubviews
        for view in arrangedViews {
            contentStackView.removeArrangedSubview(view)
            view.removeFromSuperview()
        }
    }
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "ShowSettings" {
            guard let settingsViewController = segue.destination as? SettingsTableViewController else {
                fatalError("Destination of ShowSettings segue must be SettingsTableViewController.")
            }
            
            settingsViewController.settings = settings
        }
    }
}
