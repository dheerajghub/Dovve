//
//  FollowDetailCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class FollowDetailCollectionViewCell: UICollectionViewCell {
    
    var followStatus:GetFollowingStatus?
    var data:FollowDetail?{
        didSet{
            manageData()
        }
    }
    
    let profileImage:CustomImageView = {
        let img = CustomImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.layer.cornerRadius = 25
        return img
    }()
    
    let profileBackView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        v.layer.cornerRadius = 25
        return v
    }()
    
    let name:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.dynamicColor(.textColor)
        return l
    }()
    
    let screenName:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appDarkGray
        l.font = UIFont(name: CustomFonts.appFont, size: 16)
        return l
    }()
    
    let followBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setTitle("Follow", for: .normal)
        btn.setTitleColor(CustomColors.appBlue, for: .normal)
        btn.layer.cornerRadius = 17.5
        btn.layer.borderColor = CustomColors.appBlue.cgColor
        btn.layer.borderWidth = 1.5
        btn.titleLabel?.font = UIFont(name: CustomFonts.appFontBold, size: 15)
        return btn
    }()
    
    let bioDetail:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.font = UIFont(name: CustomFonts.appFont, size: 16)
        l.textColor = UIColor.dynamicColor(.textColor)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(profileImage)
        addSubview(profileBackView)
        addSubview(name)
        addSubview(screenName)
        addSubview(followBtn)
        addSubview(bioDetail)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            profileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImage.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileImage.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            profileImage.widthAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            profileBackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileBackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileBackView.heightAnchor.constraint(lessThanOrEqualToConstant: 50),
            profileBackView.widthAnchor.constraint(lessThanOrEqualToConstant: 50),
            
            name.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            name.topAnchor.constraint(equalTo: topAnchor , constant: 15),
            name.trailingAnchor.constraint(equalTo: followBtn.leadingAnchor, constant: -10),
            name.heightAnchor.constraint(equalToConstant: 16),
            
            screenName.leadingAnchor.constraint(equalTo: profileImage.trailingAnchor, constant: 10),
            screenName.topAnchor.constraint(equalTo: name.bottomAnchor, constant: 2),
            screenName.trailingAnchor.constraint(equalTo: followBtn.leadingAnchor, constant: -10),
            screenName.heightAnchor.constraint(equalToConstant: 16),
            
            followBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            followBtn.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            followBtn.widthAnchor.constraint(equalToConstant: 90),
            followBtn.heightAnchor.constraint(equalToConstant: 35),
            
            bioDetail.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 80),
            bioDetail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            bioDetail.topAnchor.constraint(equalTo: followBtn.bottomAnchor, constant: 3),
            bioDetail.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -15)
        ])
    }
    
    func manageData(){
        guard let data = data else {return}
        profileImage.cacheImageWithLoader(withURL: data.profileImage, view: profileBackView)
        screenName.text = "@\(data.screenName ?? "")"
        name.attributedText = setUserVerifiedNameAttribute("\(data.name ?? "")" , data.isVerified ?? false , 16)
        bioDetail.text = data.bio
        
        GetFollowingStatus.fetchFollowingStatus(source_id: "893827304358424576", target_id: (data.id)!) { (followStatus) in
            self.followStatus = followStatus
        }
        guard let followStatus = followStatus else {return}
        if followStatus.isFollowing {
            self.followBtn.setTitle("Following", for: .normal)
            self.followBtn.backgroundColor = CustomColors.appBlue
            self.followBtn.setTitleColor(.white, for: .normal)
        } else {
            self.followBtn.setTitle("Follow", for: .normal)
            self.followBtn.backgroundColor = UIColor.clear
            self.followBtn.setTitleColor(CustomColors.appBlue, for: .normal)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
