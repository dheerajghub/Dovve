//
//  TrendingCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 03/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class TrendingCollectionViewCell: UICollectionViewCell {
    
    let subTitle:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appLightGray
        l.font = UIFont(name: CustomFonts.appFont, size: 15)
        return l
    }()
    
    let title:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.dynamicColor(.textColor)
        l.font = UIFont(name: CustomFonts.appFontMedium, size: 17)
        return l
    }()
    
    let tweetCount:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appLightGray
        l.font = UIFont(name: CustomFonts.appFont, size: 15)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(subTitle)
        addSubview(title)
        addSubview(tweetCount)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            subTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            subTitle.topAnchor.constraint(equalTo: topAnchor, constant: 10),
            
            title.topAnchor.constraint(equalTo: subTitle.bottomAnchor , constant: 5),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            tweetCount.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 7),
            tweetCount.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
