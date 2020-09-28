//
//  ProfileHeaderCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 20/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

protocol ButtonActionProtocol {
    func didFollowingTapped()
    func didFollowerTapped()
}

class ProfileHeaderCollectionViewCell: UICollectionViewCell {
    
    var data:UserProfile?{
        didSet {
            manageData()
        }
    }
    var delegate:ButtonActionProtocol?
    
    let profileImgView:CustomImageView = {
        let img = CustomImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 30
        img.image = UIImage(named: "demo")
        img.clipsToBounds = true
        return img
    }()
    
    let profileBackView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        v.layer.cornerRadius = 30
        return v
    }()
    
    let name:UILabel = {
        let l = UILabel()
        l.textColor = UIColor.dynamicColor(.textColor)
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
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = UIColor.dynamicColor(.textColor)
        l.font = UIFont(name: CustomFonts.appFont, size: 17)
        l.numberOfLines = 0
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
    
    //MARK:- Followings
    
    lazy var followingBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(followingBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    //MARK:- Followers
    
    lazy var followerBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.addTarget(self, action: #selector(followerBtnPressed), for: .touchUpInside)
        return btn
    }()
    
    let joinedLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appDarkGray
        l.font = UIFont(name: CustomFonts.appFont, size: 15)
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(profileImgView)
        addSubview(profileBackView)
        addSubview(followBtn)
        addSubview(name)
        addSubview(screenName)
        addSubview(bioDetail)
        addSubview(joinedLabel)
        addSubview(followingBtn)
        addSubview(followerBtn)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            profileImgView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileImgView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImgView.widthAnchor.constraint(equalToConstant: 60),
            profileImgView.heightAnchor.constraint(equalToConstant: 60),
            
            profileBackView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileBackView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileBackView.widthAnchor.constraint(equalToConstant: 60),
            profileBackView.heightAnchor.constraint(equalToConstant: 60),
            
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
            bioDetail.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            
            followBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            followBtn.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            followBtn.widthAnchor.constraint(equalToConstant: 90),
            followBtn.heightAnchor.constraint(equalToConstant: 35)
        ])
    }
    
    func customAttribute(_ count:String , attr:String , btn:UIButton) {
        let attributedText = NSMutableAttributedString(string:"\(count)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 15)!, NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)])
        
        attributedText.append(NSAttributedString(string: " \(attr)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 15)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        btn.setAttributedTitle(attributedText, for: .normal)
    }
    
    func manageData(){
        guard let data = data else { return }
        customAttribute("\(Double(data.followers ?? 0).kmFormatted)", attr: "Follower" , btn: followerBtn)
        customAttribute("\(Double(data.friends ?? 0).kmFormatted)", attr: "Following", btn:followingBtn)
        screenName.text = "@\(data.screenName ?? "")"
        bioDetail.text = "\(data.bio ?? "")"
        guard let joiningDate = data.joiningDate else {return}
        joinedLabel.text = "Joined \(joiningDate.parseTwitterDateInFormat("MMMM yyyy") ?? "")"
        profileImgView.cacheImageWithLoader(withURL: "\(data.profileImage ?? "")", view: profileBackView)
        name.attributedText = setUserVerifiedNameAttribute("\(data.name ?? "")" , data.isVerified ?? false , 22)
        
//        GetFollowingStatus.fetchFollowingStatus(source_id: "893827304358424576", target_id: (data.id)!) { (followStatus) in
//            if followStatus.isFollowing {
//                self.followBtn.setTitle("Following", for: .normal)
//                self.followBtn.backgroundColor = CustomColors.appBlue
//                self.followBtn.setTitleColor(.white, for: .normal)
//            } else {
//                self.followBtn.setTitle("Follow", for: .normal)
//                self.followBtn.backgroundColor = UIColor.clear
//                self.followBtn.setTitleColor(CustomColors.appBlue, for: .normal)
//            }
//        }
    }
    
    @objc func followerBtnPressed(){
        delegate?.didFollowerTapped()
    }
    
    @objc func followingBtnPressed(){
        delegate?.didFollowingTapped()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
