//
//  ArticleCollectionViewCell.swift
//  Xishuipang
//
//  Created by Xiangyu Luo on 2018-12-15.
//  Copyright © 2018 Chinese Gospel Church. All rights reserved.
//

import UIKit

class ArticleCollectionViewCell: UICollectionViewCell{
    
    // MARK: attributes
    @IBInspectable let cornerRadius:CGFloat = 20.0
    
    // MARK: outlets
    @IBOutlet weak var cellView: UIView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var authorLabel: UILabel!
    @IBOutlet weak var categoryLabel: UILabel!
    @IBOutlet weak var backgroundImage: UIImageView!

    
    // MARK: properties
    var article : Article?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width:0, height: 0.5)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        let path = CGPath(rect: bounds, transform: nil)
        layer.shadowPath = path
        
        cellView.layer.cornerRadius = cornerRadius
        cellView.layer.masksToBounds = true
        
    }
    
    func loadArticleToView() {
        if let article = article {
            titleLabel.text = article.title
            authorLabel.text = article.author
            categoryLabel.text = article.category
            if article.images.count > 0 {
                backgroundImage.isHidden = false
                backgroundImage.image = article.images.first?.value
            }
        }
    }
}
