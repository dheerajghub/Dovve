//
//  ProfileStrechyHeader.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 20/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ProfileStrechyHeader: UICollectionReusableView {
       
    var imageView: CustomImageView!
    var imageBackView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return v
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        createViews()
        setViewConstraints()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    func createViews() {
        imageView = CustomImageView()
        imageView.videoView.isHidden = true
        imageView.clipsToBounds = true
        imageView.contentMode = .scaleAspectFill
        self.addSubview(imageView)
        self.addSubview(imageBackView)
    }
    
    func setViewConstraints() {
        imageView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.imageView.topAnchor.constraint(equalTo: self.topAnchor),
            self.imageView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.imageView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.imageView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
            
            imageBackView.topAnchor.constraint(equalTo: self.topAnchor),
            imageBackView.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            imageBackView.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            imageBackView.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
    }

}
