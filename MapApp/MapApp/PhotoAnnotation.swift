//
//  PhotoAnnotation.swift
//  MapApp
//
//  Created by MacMini on 09/07/2019.
//  Copyright © 2019 com.blablabla. All rights reserved.
//

import UIKit
import Cluster

class PhotoAnnotation: Annotation {
    let image: UIImage
    
    init(image: UIImage) {
    self.image = image
    super.init()
        
    style = .image(image)
    }
}

extension PhotoAnnotation {
    
    var resizedImage: UIImage? {
        
        let size = CGSize(width: 40, height: 40)
        
        UIGraphicsBeginImageContext(size)
        
        image.draw(in: CGRect(origin: .zero, size: size))
        let resizedImage = UIGraphicsGetImageFromCurrentImageContext()
        
        UIGraphicsEndImageContext()
        
        return resizedImage
    }
    
    
    
}
