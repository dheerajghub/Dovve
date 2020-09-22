//
//  ImageCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var data:String!{
        didSet {
            image.image = UIImage(named: data)
        }
    }
    
    let image:UIImageView = {
        let img = UIImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "demo")
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(image)
        image.pin(to: self)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
