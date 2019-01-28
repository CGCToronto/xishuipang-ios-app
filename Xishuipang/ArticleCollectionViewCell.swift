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
    @IBOutlet weak var previewTextView: UITextView!
    
    // MARK: properties
    var article : Article?
    var originalSize: CGSize?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // Initialization code
        originalSize = self.bounds.size
        updateShadow(with: self.bounds)
    }
    
    func loadArticleToView() {
        if let article = article {
            titleLabel.text = article.title
            authorLabel.text = article.author
            categoryLabel.text = article.category
            if article.images.count > 0 {
                backgroundImage.isHidden = false
                backgroundImage.image = article.images.first?.value
                previewTextView.isHidden = true
                previewTextView.text = ""
            } else {
                backgroundImage.isHidden = true
                backgroundImage.image = nil
                previewTextView.isHidden = false
                previewTextView.text = article.getExcerpt()
            }
        }
    }
    
    fileprivate func updateShadow(with bound: CGRect) {
        layer.cornerRadius = cornerRadius
        layer.masksToBounds = false
        layer.shadowColor = UIColor.gray.cgColor
        layer.shadowOffset = CGSize(width:0, height: 0.5)
        layer.shadowOpacity = 0.5
        layer.shadowRadius = 10
        let path = CGPath(rect: bound, transform: nil)
        layer.shadowPath = path
        
        cellView.layer.cornerRadius = cornerRadius
        cellView.layer.masksToBounds = true
    }
    
    fileprivate func updateFrameAndBoundSize(with size: CGSize)
    {
        self.frame.size = size
        self.bounds.size = size
        updateShadow(with: self.bounds)
    }
}
