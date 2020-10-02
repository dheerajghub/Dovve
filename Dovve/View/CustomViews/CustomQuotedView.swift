//
//  CustomQuotedView.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import ActiveLabel

class CustomQuotedView: UIView {
    
    var ActionDelegate:QuotedActionProtocol?
    var delegate:QuotedPostCollectionViewCell? {
        didSet {
            tap.addTarget(delegate!, action: #selector(QuotedPostCollectionViewCell.quotedUserProfileSelected))
        }
    }
    var delegate2:PostWithImageAndQuoteCollectionViewCell?{
        didSet{
            tap.addTarget(delegate2!, action: #selector(QuotedPostCollectionViewCell.quotedUserProfileSelected))
        }
    }
    
    let tap = UITapGestureRecognizer()
    lazy var profileImageView:CustomImageView = {
        let img = CustomImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.contentMode = .scaleAspectFill
        img.image = UIImage(named: "demo")
        img.clipsToBounds = true
        img.layer.cornerRadius = 12.5
        tap.numberOfTapsRequired = 1
        img.addGestureRecognizer(tap)
        img.isUserInteractionEnabled = true
        img.videoView.isHidden = true
        return img
    }()
    
    let profileBackImageView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        v.layer.cornerRadius = 12.5
        return v
    }()
    
    let userInfo:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let tweet:ActiveLabel = {
        let l = ActiveLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont(name: CustomFonts.appFont, size: 17)
        l.textColor = UIColor.dynamicColor(.textColor)
        l.text = "This is test this test this."
        l.numberOfLines = 0
        l.enabledTypes = [.mention , .hashtag , .url]
        return l
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(profileImageView)
        addSubview(profileBackImageView)
        addSubview(userInfo)
        addSubview(tweet)
        setUpConstraints()
        
        setUpActiveLabels()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileImageView.widthAnchor.constraint(equalToConstant: 25),
            profileImageView.heightAnchor.constraint(equalToConstant: 25),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            profileBackImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            profileBackImageView.widthAnchor.constraint(equalToConstant: 25),
            profileBackImageView.heightAnchor.constraint(equalToConstant: 25),
            profileBackImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            
            userInfo.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            userInfo.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            userInfo.heightAnchor.constraint(equalToConstant: 25),
            
            tweet.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 15),
            tweet.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -15),
            tweet.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            tweet.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5)
            
        ])
    }
    
    func setUpActiveLabels(){
        //Customizing Labels
        tweet.customize{ label in
            label.hashtagColor = CustomColors.appBlue
            label.mentionColor = CustomColors.appBlue
            label.URLColor = CustomColors.appBlue
        }
        
        tweet.handleURLTap { (url) in
            self.ActionDelegate?.didUrlTapped("\(url)")
        }
        
        tweet.handleMentionTap { (screenName) in
            self.ActionDelegate?.didMentionTapped(screenName: screenName)
        }
        
        tweet.handleHashtagTap { (hashtag) in
            self.ActionDelegate?.didHashtagTapped(hashtag)
        }
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func setUpAttributes( _ name:String, _ userName:String , _ time:String, _ isVerified:Bool){
        let attributedText = NSMutableAttributedString(string:"\(name) " , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue-Medium", size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)])
        
        if isVerified {
            let font = UIFont.systemFont(ofSize: 16)
            let verifiyImg = UIImage(named:"verify")
            let verifiedImage = NSTextAttachment()
            verifiedImage.image = verifiyImg
            verifiedImage.bounds = CGRect(x: 0, y: (font.capHeight - 16).rounded() / 2, width: 16, height: 16)
            verifiedImage.setImageHeight(height: 16)
            let imgString = NSAttributedString(attachment: verifiedImage)
            attributedText.append(imgString)
        }
        
        attributedText.append(NSAttributedString(string: " @\(userName)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        attributedText.append(NSAttributedString(string: " • \(time)" , attributes:[NSAttributedString.Key.font: UIFont(name: "HelveticaNeue", size: 17)!, NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
        
        userInfo.attributedText = attributedText
    }
    
}
