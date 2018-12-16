//
//  ArticleCollectionViewCell.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-15.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell {
    
    // MARK: outlets
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var previewTextView: UITextView!
    
    // MARK: properties
    var article : Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func loadArticleToView() {
        if let article = article {
            titleLabel.text = article.title
            authorLabel.text = article.author
            categoryLabel.text = article.category
            previewTextView.text = article.content[0]
        }
    }
}
