//
//  CategoryMenuCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 01/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CategoryMenuCollectionViewCell: UICollectionViewCell {
    
    override var isHighlighted: Bool{
        didSet{
            categoryLabel.textColor = isHighlighted ? CustomColors.appBlue : CustomColors.appDarkGray
        }
    }
    
    override var isSelected: Bool{
        didSet{
            categoryLabel.textColor = isSelected ? CustomColors.appBlue : CustomColors.appDarkGray
        }
    }
    
    let categoryLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: CustomFonts.appFontBold, size: 15)
        l.textColor = CustomColors.appDarkGray
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(categoryLabel)
        setUpViews()
    }
    
    func setUpViews(){
        NSLayoutConstraint.activate([
            categoryLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            categoryLabel.centerXAnchor.constraint(equalTo: centerXAnchor)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
