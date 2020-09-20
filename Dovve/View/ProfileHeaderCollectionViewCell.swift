//
//  ProfileHeaderCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 20/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class ProfileHeaderCollectionViewCell: UICollectionViewCell {
    
    let profileImgView:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 30
        img.image = UIImage(named: "demo")
        img.clipsToBounds = true
        return img
    }()
    
    let name:UILabel = {
        let l = UILabel()
        l.text = "Dheeraj"
        l.textColor = CustomColors.appBlack
        l.font = UIFont(name: CustomFonts.appFontBold, size: 22)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let screenName:UILabel = {
        let l = UILabel()
        l.text = "@dheerajdev_twit"
        l.textColor = CustomColors.appDarkGray
        l.font = UIFont(name: CustomFonts.appFont, size: 17)
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let bioDetail:UILabel = {
        let l = UILabel()
        l.text = "iOS Developer, XDian 😅"
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appBlack
        l.font = UIFont(name: CustomFonts.appFont, size: 17)
        return l
    }()
    
    //MARK:- Followings
    
    let followingBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    //MARK:- Followers
    
    let followerBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        return btn
    }()
    
    let joinedLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.text = "Joined August 2017"
        l.textColor = CustomColors.appDarkGray
        l.font = UIFont(name: CustomFonts.appFont, size: 15)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImgView)
        addSubview(name)
        addSubview(screenName)
        addSubview(bioDetail)
        addSubview(joinedLabel)
        addSubview(followingBtn)
        addSubview(followerBtn)
        
        setUpConstraints()
        
        customAttribute("4,334", attr: "Follower" , btn: followerBtn)
        customAttribute("1,545", attr: "Following", btn:followingBtn)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            profileImgView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileImgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImgView.widthAnchor.constraint(equalToConstant: 60),
            profileImgView.heightAnchor.constraint(equalToConstant: 60),
            
            name.topAnchor.constraint(equalTo: profileImgView.bottomAnchor , constant: 5),
            name.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            name.heightAnchor.constraint(equalToConstant: 32),
            name.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            screenName.topAnchor.constraint(equalTo: name.bottomAnchor , constant: 2),
            screenName.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            screenName.heightAnchor.constraint(equalToConstant: 20),
            screenName.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            followingBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            followingBtn.heightAnchor.constraint(equalToConstant: 30),
            followingBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            
            followerBtn.leadingAnchor.constraint(equalTo: followingBtn.trailingAnchor, constant: 10),
            followerBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15),
            followerBtn.heightAnchor.constraint(equalToConstant: 30),
            
            joinedLabel.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            joinedLabel.bottomAnchor.constraint(equalTo: followingBtn.topAnchor, constant: -3),
            joinedLabel.heightAnchor.constraint(equalToConstant: 18),
            
            bioDetail.topAnchor.constraint(equalTo: screenName.bottomAnchor, constant: 5),
            bioDetail.bottomAnchor.constraint(equalTo: joinedLabel.topAnchor, constant: -5),
            bioDetail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            bioDetail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20)
        ])
    }
    
    func customAttribute(_ count:String , attr:String , btn:UIButton) {
        let attributedText = NSMutableAttributedString(string:"\(count)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: CustomColors.appBlack])
        
        attributedText.append(NSAttributedString(string: " \(attr)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        btn.setAttributedTitle(attributedText, for: .normal)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
