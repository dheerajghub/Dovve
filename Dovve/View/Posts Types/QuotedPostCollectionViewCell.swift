//
//  QuotedPostCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class QuotedPostCollectionViewCell: UICollectionViewCell {
  
    var data:TweetData?{
        didSet{
            manageData()
        }
    }
    
    var quotedViewHeightContraints:NSLayoutConstraint?
    
    let userProfileImage:CustomImageView = {
        let img = CustomImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.backgroundColor = .lightGray
        img.layer.cornerRadius = 25
        return img
    }()
    
    let userBackImageView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        v.layer.cornerRadius = 25
        return v
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
        l.textColor = UIColor.dynamicColor(.textColor)
        l.numberOfLines = 0
        return l
    }()
    
    lazy var quotedView:CustomQuotedView = {
        let v = CustomQuotedView()
        v.delegate = self
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 15
        v.layer.borderColor = UIColor.dynamicColor(.secondaryBackground).cgColor
        v.layer.borderWidth = 0.7
        return v
    }()
    
    let stackView:UIStackView = {
        let v = UIStackView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.spacing = 10
        v.distribution = .fillEqually
        v.axis = .horizontal
        return v
    }()
    
    //MARK:- Comment View
    let commentView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .clear
        return v
    }()
    
    let commentImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named:"comment")
        return img
    }()
    
    let commentLabel:UILabel = {
        let l = UILabel()
        l.text = "34"
        l.font = UIFont(name: "HelveticaNeue", size: 15)
        l.textColor = CustomColors.appDarkGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    //MARK:- Retweet View
    
    let retweetView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let retweetImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named:"retweet")
        return img
    }()
    
    let retweetLabel:UILabel = {
        let l = UILabel()
        l.text = "34"
        l.font = UIFont(name: "HelveticaNeue", size: 15)
        l.textColor = CustomColors.appDarkGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    //MARK:- Like View
    
    let likeView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let likeImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named:"heart")
        return img
    }()
    
    let likeLabel:UILabel = {
        let l = UILabel()
        l.text = "34"
        l.font = UIFont(name: "HelveticaNeue", size: 15)
        l.textColor = CustomColors.appDarkGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    //MARK:- Share View
    
    let shareView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let shareImage:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named:"share")
        return img
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(userProfileImage)
        addSubview(userBackImageView)
        addSubview(userInfo)
        addSubview(tweet)
        addSubview(quotedView)
        addSubview(stackView)
        stackView.addArrangedSubview(commentView)
        commentView.addSubview(commentImage)
        commentView.addSubview(commentLabel)
        
        stackView.addArrangedSubview(retweetView)
        retweetView.addSubview(retweetImage)
        retweetView.addSubview(retweetLabel)
        
        stackView.addArrangedSubview(likeView)
        likeView.addSubview(likeImage)
        likeView.addSubview(likeLabel)
        
        stackView.addArrangedSubview(shareView)
        shareView.addSubview(shareImage)
        
        setUpConstraints()
    }
    
    func setUpConstraints(){
        
        NSLayoutConstraint.activate([
            userProfileImage.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userProfileImage.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userProfileImage.widthAnchor.constraint(equalToConstant: 50),
            userProfileImage.heightAnchor.constraint(equalToConstant: 50),
            
            userBackImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            userBackImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userBackImageView.widthAnchor.constraint(equalToConstant: 50),
            userBackImageView.heightAnchor.constraint(equalToConstant: 50),
            
            userInfo.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userInfo.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor , constant: 10),
            userInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userInfo.heightAnchor.constraint(equalToConstant: 20),
            
            tweet.topAnchor.constraint(equalTo: userInfo.bottomAnchor, constant: 5),
            tweet.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            tweet.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tweet.bottomAnchor.constraint(equalTo: quotedView.topAnchor, constant: -10),
            
            quotedView.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            quotedView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            quotedView.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -10),
            
            stackView.leadingAnchor.constraint(equalTo: userProfileImage.trailingAnchor, constant: 10),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            stackView.heightAnchor.constraint(equalToConstant: 30),
            
            commentImage.leadingAnchor.constraint(equalTo: commentView.leadingAnchor),
            commentImage.centerYAnchor.constraint(equalTo: commentView.centerYAnchor),
            commentImage.widthAnchor.constraint(equalToConstant: 20),
            commentImage.heightAnchor.constraint(equalToConstant: 20),
            
            commentLabel.leadingAnchor.constraint(equalTo: commentImage.trailingAnchor, constant: 6),
            commentLabel.centerYAnchor.constraint(equalTo: commentView.centerYAnchor),
            
            retweetImage.leadingAnchor.constraint(equalTo: retweetView.leadingAnchor),
            retweetImage.centerYAnchor.constraint(equalTo: retweetView.centerYAnchor),
            retweetImage.widthAnchor.constraint(equalToConstant: 20),
            retweetImage.heightAnchor.constraint(equalToConstant: 20),
            
            retweetLabel.leadingAnchor.constraint(equalTo: retweetImage.trailingAnchor, constant: 6),
            retweetLabel.centerYAnchor.constraint(equalTo: retweetView.centerYAnchor),
            
            likeImage.leadingAnchor.constraint(equalTo: likeView.leadingAnchor),
            likeImage.centerYAnchor.constraint(equalTo: likeView.centerYAnchor),
            likeImage.widthAnchor.constraint(equalToConstant: 20),
            likeImage.heightAnchor.constraint(equalToConstant: 20),
            
            likeLabel.leadingAnchor.constraint(equalTo: likeImage.trailingAnchor, constant: 6),
            likeLabel.centerYAnchor.constraint(equalTo: likeView.centerYAnchor),
            
            shareImage.leadingAnchor.constraint(equalTo: shareView.leadingAnchor),
            shareImage.centerYAnchor.constraint(equalTo: shareView.centerYAnchor),
            shareImage.widthAnchor.constraint(equalToConstant: 20),
            shareImage.heightAnchor.constraint(equalToConstant: 20),
        ])
    }
    
    func manageData(){
        guard let data = data else {return}
        userInfo.attributedText = setUserInfoAttributes(data.user.name, data.user.screenName, data.createdAt, data.user.isVerified)
        userProfileImage.cacheImageWithLoader(withURL: data.user.profileImage, view: userBackImageView)
        tweet.text = data.text
        commentLabel.text = ""
        retweetLabel.text = "\(data.retweetCount ?? 0)"
        likeLabel.text = "\(data.favoriteCount ?? 0)"
        
        //Quoted View data
        quotedView.profileImageView.cacheImageWithLoader(withURL: data.tweetQuotedStatus.user.profileImage, view: quotedView.profileBackImageView)
        quotedView.userInfo.attributedText = setUserInfoAttributes(data.tweetQuotedStatus.user.name, data.tweetQuotedStatus.user.screenName, data.tweetQuotedStatus.createdAt, data.tweetQuotedStatus.user.isVerified)
        quotedView.tweet.text = data.tweetQuotedStatus.text
        
        let font = UIFont(name: CustomFonts.appFont, size: 17)!
        let estimatedH = data.tweetQuotedStatus.text.height(withWidth: ((self.frame.width - 100) - 30), font: font)
        quotedViewHeightContraints = quotedView.heightAnchor.constraint(equalToConstant: estimatedH + 60)
        quotedViewHeightContraints?.isActive = true
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
