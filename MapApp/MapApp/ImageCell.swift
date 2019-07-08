//
//  ImageCell.swift
//  MapApp
//
//  Created by MacMini on 08/07/2019.
//  Copyright © 2019 com.blablabla. All rights reserved.
//

import UIKit

class ImageCell: UICollectionViewCell {
    
    @IBOutlet weak var photoImage: UIImageView!
    
    func populate (with image: UIImage) {
        photoImage.image = image
    }
    
}
