//
//  HeaderTableViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 03/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class HeaderTableViewCell: UITableViewCell {

    let headerText:UILabel = {
        let l = UILabel()
        l.font = UIFont(name: CustomFonts.appFontBold, size: 18)
        l.textColor = UIColor.dynamicColor(.textColor)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        backgroundColor = UIColor.dynamicColor(.darkBackground)
        addSubview(headerText)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            headerText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            headerText.centerYAnchor.constraint(equalTo: centerYAnchor),
            headerText.trailingAnchor.constraint(equalTo: trailingAnchor, constant:  -20)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
