//
//  DefaultCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 28/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class DefaultCollectionViewCell: UICollectionViewCell {
    
    let title:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.textColor = UIColor.dynamicColor(.textColor)
        l.font = UIFont(name: CustomFonts.appFontBold, size: 20)
        return l
    }()
    
    let subTitle:UILabel = {
        let l = UILabel()
        l.numberOfLines = 0
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textAlignment = .center
        l.textColor = CustomColors.appDarkGray
        l.font = UIFont(name: CustomFonts.appFont, size: 16)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(title)
        addSubview(subTitle)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 25),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            title.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            title.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 10),
            subTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            subTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
