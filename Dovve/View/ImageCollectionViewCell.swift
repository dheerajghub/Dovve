//
//  ImageCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ImageCollectionViewCell: UICollectionViewCell {
    
    var data:TweetMediaData?{
        didSet {
            manageData()
        }
    }
    
    let image:CustomImageView = {
        let img = CustomImageView()
        img.clipsToBounds = true
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "demo")
        return img
    }()
    
    let userImageBackView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userImageBackView)
        addSubview(image)
        userImageBackView.pin(to: self)
        image.pin(to: self)
    }
    
    func manageData(){
        guard let data = data else {return}
        image.cacheImageWithLoader(withURL: data.imgURL, view: userImageBackView)
        image.videoView.isHidden = data.isVideo ? false : true
        if data.duration == nil {
            image.status.setTitle(" GIF ", for: .normal)
        } else {
            let seconds = data.duration.stringFromMillis()
            image.status.setTitle(" \(seconds) ", for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
