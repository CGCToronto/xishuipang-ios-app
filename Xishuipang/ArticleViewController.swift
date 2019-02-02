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
    var article = Article()
    var settings : Settings?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        loadArticleContentToView()
    }
    
    // MARK: private methods
    func loadArticleContentToView() {
        
        categoryLabel.text = article.category
        titleLabel.text = article.title
        authorLabel.text = article.author
        
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
                let font = UIFont.preferredFont(forTextStyle: .body).withSize(20)
                let paragraphStyle = NSMutableParagraphStyle()
                paragraphStyle.lineSpacing = 8
                let attributes = [NSAttributedStringKey.paragraphStyle: paragraphStyle, NSAttributedStringKey.font: font]
                lineTextView.attributedText = NSAttributedString(string: line, attributes: attributes)
                contentStackView.addArrangedSubview(lineTextView)
            }
        }
    }

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
