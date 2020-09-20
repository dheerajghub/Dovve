//
//  HomeFeedCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 19/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class HomeFeedCollectionViewCell: UICollectionViewCell {
    
    let userProfileImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .lightGray
        img.layer.cornerRadius = 25
        return img
    }()
    
    let userInfo:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let tweet:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: CustomFonts.appFont, size: 17)
        l.text = "Long converstion goes here, tweet content goes here. Long converstion goes here, tweet content goes here. Long converstion goes here."
        l.textColor = CustomColors.appBlack
        l.numberOfLines = 0
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(userProfileImage)
        addSubview(userInfo)
        addSubview(tweet)
        setUpConstraints()
        
        setUpAttributes("Full name", "username", "2h")
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            userProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userProfileImage.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userProfileImage.widthAnchor.constraint(equalToConstant: 50),
            userProfileImage.heightAnchor.constraint(equalToConstant: 50),
            
            userInfo.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userInfo.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor , constant: 10),
            userInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userInfo.heightAnchor.constraint(equalToConstant: 20),
            
            tweet.topAnchor.constraint(equalTo: userInfo.bottomAnchor, constant: 5),
            tweet.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            tweet.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tweet.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    func setUpAttributes( _ name:String, _ userName:String , _ time:String){
        let attributedText = NSMutableAttributedString(string:"\(name) " , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 17)!])
        
        let font = UIFont.systemFont(ofSize: 17)
        let verifiyImg = UIImage(named:"verify")
        let verifiedImage = NSTextAttachment()
        verifiedImage.image = verifiyImg
        verifiedImage.bounds = CGRect(x: 0, y: (font.capHeight - 17).rounded() / 2, width: 17, height: 17)
        verifiedImage.setImageHeight(height: 17)
        let imgString = NSAttributedString(attachment: verifiedImage)
        attributedText.append(imgString)
        
        attributedText.append(NSAttributedString(string: " @\(userName)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        attributedText.append(NSAttributedString(string: " • \(time)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)!, NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        userInfo.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
