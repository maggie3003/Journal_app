//
//  imageCell.swift
//  Journal
//
//  Created by Meiqi You on 30/08/2015.
//  Copyright (c) 2015 Meiqi You. All rights reserved.
//

import UIKit

class imageCell: UICollectionViewCell {
    
    @IBOutlet weak var imageView: UIImageView!
  
   /* func setThumbnailImage(thumbnailImage: UIImage){
        self.imageView.image = thumbnailImage
    }
    */
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }
    
    func setSelected(selected: Bool, animated: Bool) {
        super.select(selected)
       // super.setSelected()
        
        // Configure the view for the selected state
    }

}
