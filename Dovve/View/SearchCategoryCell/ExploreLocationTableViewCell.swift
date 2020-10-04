//
//  ExploreLocationTableViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 04/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ExploreLocationTableViewCell: UITableViewCell {
    
    let textTitleLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.dynamicColor(.textColor)
        l.text = "Explore Locations"
        l.font = UIFont(name: CustomFonts.appFontMedium, size: 15)
        return l
    }()
    
    let detailLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appDarkGray
        l.text = "Select"
        l.font = UIFont(name: CustomFonts.appFont, size: 14)
        l.textAlignment = .right
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(textTitleLabel)
        addSubview(detailLabel)
        setUpConstriants()
        setUpViews()
    }
    
    func setUpViews(){
        self.accessoryType = .disclosureIndicator
        self.separatorInset = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
        self.backgroundColor = UIColor.dynamicColor(.appBackground)
        self.selectionStyle = .none
    }
    
    func setUpConstriants(){
        NSLayoutConstraint.activate([
            textTitleLabel.leadingAnchor.constraint(equalTo: leadingAnchor , constant: 20),
            textTitleLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -40),
            detailLabel.centerYAnchor.constraint(equalTo: centerYAnchor),
            detailLabel.leadingAnchor.constraint(equalTo: textTitleLabel.trailingAnchor, constant: 5)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
