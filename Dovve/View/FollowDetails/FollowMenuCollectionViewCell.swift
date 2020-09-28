//
//  FollowMenuCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class FollowMenuCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            followLabel.textColor = isHighlighted ? CustomColors.appBlue : CustomColors.appDarkGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            followLabel.textColor = isSelected ? CustomColors.appBlue : CustomColors.appDarkGray
        }
    }
    
    let followLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: CustomFonts.appFontBold, size: 15)
        l.text = "Followers"
        l.textColor = CustomColors.appDarkGray
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(followLabel)
        setUpViews()
    }
    
    func setUpViews(){
        NSLayoutConstraint.activate([
            followLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            followLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
