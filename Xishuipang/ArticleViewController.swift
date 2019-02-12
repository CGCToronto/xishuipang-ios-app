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
    @IBOutlet weak var contentStackView: UIStackView!
    
    // MARK: properties
    var article : Article?
    var settings : Settings?
    var fontSize : Int = 30
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadArticleContentToView()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if let article = article, let settings = settings {
            if article.characterVersion != settings.characterVersion {
                article.changeArticleCharacterVersion(settings.characterVersion)
                // Change article id here to properly get the correct article.
                article.loadArticleContentFromServer {
                    DispatchQueue.main.async {
                        self.loadArticleContentToView()
                    }
                }
            } else if fontSize != settings.fontSize {
                loadArticleContentToView()
            }
        }
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
                    
                    let stackViewWidth = contentStackView.frame.width
                    
                    let imageFileName = article.getImageFilenameFromImageTag(line: line)
                    if let image = article.images[imageFileName] {
                        let resizedImage = image.resizeWithAspectRatio(toFitIn: CGSize(width:stackViewWidth, height:stackViewWidth))
                        let imageView = UIImageView(image: resizedImage)
                        imageView.contentMode = .scaleAspectFit
                        contentStackView.addArrangedSubview(imageView)
                    }
                } else if !article.isEmpty(line: line) {
                    let lineTextView = UITextView()
                    lineTextView.isScrollEnabled = false
                    lineTextView.isEditable = false

                    let paragraphStyle = NSMutableParagraphStyle()
                    paragraphStyle.lineSpacing = 8
                    let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: font]
                    lineTextView.attributedText = NSAttributedString(string: line, attributes: attributes)
                    contentStackView.addArrangedSubview(lineTextView)
                }
            }
        }
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
