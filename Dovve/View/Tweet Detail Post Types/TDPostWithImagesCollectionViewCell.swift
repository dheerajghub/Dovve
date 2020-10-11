//
//  TDPostWithImagesCollectionViewCell.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 10/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import ActiveLabel

protocol TDPostWithImagesDelegate{
    func didUserProfileTapped(for cell: TDPostWithImagesCollectionViewCell , _ isRetweetedUser:Bool)
    func didImageTapped(for cell:TDPostWithImagesCollectionViewCell , _ index:Int)
    func didUrlTapped(url:String)
    func didMentionTapped(screenName:String)
    func didHashtagTapped(_ hashtag:String)
}

class TDPostWithImagesCollectionViewCell: UICollectionViewCell {

    var data:TweetData?{
        didSet{
            manageData()
            collectionView.reloadData()
        }
    }
    var delegate:TDPostWithImagesDelegate?
    
    let profileImageView:CustomImageView = {
        let img = CustomImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named:"demo")
        img.layer.cornerRadius = 25
        let tap = UITapGestureRecognizer(target: self, action: #selector(userProfileSelected))
        tap.numberOfTapsRequired = 1
        img.addGestureRecognizer(tap)
        img.isUserInteractionEnabled = true
        img.videoView.isHidden = true
        return img
    }()

    let profileLoaderView:CustomImageLoader = {
        let v = CustomImageLoader()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.cornerRadius = 25
        return v
    }()

    let userInfo:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.text = "Dheeraj \n @username"
        return l
    }()

    let tweet:ActiveLabel = {
        let l = ActiveLabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.enabledTypes = [.hashtag , .mention , .url]
        l.numberOfLines = 0
        l.font = UIFont(name: CustomFonts.appFontLight, size: 20)
        return l
    }()

    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.setCollectionViewLayout(layout, animated: false)
        cv.backgroundColor = UIColor.dynamicColor(.appBackground)
        cv.layer.cornerRadius = 15
        cv.layer.borderWidth = 0.7
        cv.delegate = self
        cv.dataSource = self
        cv.register(ImageCollectionViewCell.self, forCellWithReuseIdentifier: "ImageCollectionViewCell")
        cv.layer.borderColor = UIColor.dynamicColor(.secondaryBackground).cgColor
        return cv
    }()

    //MARK:- Remains same for all post types

    let createdAt:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.textColor = CustomColors.appDarkGray
        l.text = "2:00AM 09/03/19 • Twitter with iphone"
        l.font = UIFont(name: CustomFonts.appFont, size: 15)
        return l
    }()

    let dividerLine1:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return v
    }()

    lazy var retweetsWithBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setAttributedTitle(setMetricDataAttribute("Retweets" , "123"),for: .normal)
        return btn
    }()

    lazy var quoteTweetWithBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setAttributedTitle(setMetricDataAttribute("Quote Tweets" , "12"),for: .normal)
        return btn
    }()

    lazy var tweetLikedWithBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setAttributedTitle(setMetricDataAttribute("Likes" , "349"),for: .normal)
        return btn
    }()

    let dividerLine2:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return v
    }()

    let stackView:UIStackView = {
        let sv = UIStackView()
        sv.translatesAutoresizingMaskIntoConstraints = false
        sv.spacing = 0
        sv.axis = .horizontal
        sv.distribution = .fillEqually
        return sv
    }()

    let messageBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "comment"), for: .normal)
        return btn
    }()

    let retweetBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "retweet"), for: .normal)
        return btn
    }()

    let likeBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "heart"), for: .normal)
        return btn
    }()

    let shareBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.setImage(UIImage(named: "share"), for: .normal)
        return btn
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        backgroundColor = UIColor.dynamicColor(.appBackground)
        addSubview(profileLoaderView)
        addSubview(profileImageView)
        addSubview(userInfo)
        addSubview(tweet)
        addSubview(collectionView)
        addSubview(createdAt)
        addSubview(dividerLine1)
        addSubview(dividerLine2)
        addSubview(retweetsWithBtn)
        addSubview(quoteTweetWithBtn)
        addSubview(tweetLikedWithBtn)
        addSubview(stackView)
        stackView.addArrangedSubview(messageBtn)
        stackView.addArrangedSubview(retweetBtn)
        stackView.addArrangedSubview(likeBtn)
        stackView.addArrangedSubview(shareBtn)
        setUpConstraints()

        userInfo.attributedText = setTweetDetailUserInfoAttributes("Dheeraj", "dheerajdev_twit", true)
    }

    func setUpConstraints(){
        NSLayoutConstraint.activate([
            profileLoaderView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileLoaderView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileLoaderView.heightAnchor.constraint(equalToConstant: 50),
            profileLoaderView.widthAnchor.constraint(equalToConstant: 50),

            profileImageView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            profileImageView.topAnchor.constraint(equalTo: topAnchor, constant: 15),
            profileImageView.heightAnchor.constraint(equalToConstant: 50),
            profileImageView.widthAnchor.constraint(equalToConstant: 50),

            userInfo.leadingAnchor.constraint(equalTo: profileImageView.trailingAnchor, constant: 10),
            userInfo.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            userInfo.topAnchor.constraint(equalTo: topAnchor, constant: 20),

            tweet.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            tweet.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            tweet.topAnchor.constraint(equalTo: profileImageView.bottomAnchor, constant: 5),
            tweet.bottomAnchor.constraint(equalTo: collectionView.topAnchor, constant: -10),
            
            collectionView.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            collectionView.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            collectionView.heightAnchor.constraint(equalToConstant: (self.frame.width - 40) * (9/16)),
            collectionView.bottomAnchor.constraint(equalTo: createdAt.topAnchor, constant:-10),

            createdAt.leadingAnchor.constraint(equalTo: leadingAnchor, constant:20),
            createdAt.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            createdAt.heightAnchor.constraint(equalToConstant: 20),
            createdAt.bottomAnchor.constraint(equalTo: dividerLine1.topAnchor, constant: -10),

            dividerLine1.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dividerLine1.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dividerLine1.heightAnchor.constraint(equalToConstant: 0.7),
            dividerLine1.bottomAnchor.constraint(equalTo: retweetsWithBtn.topAnchor, constant: -10),

            retweetsWithBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            retweetsWithBtn.heightAnchor.constraint(equalToConstant: 25),
            retweetsWithBtn.bottomAnchor.constraint(equalTo: dividerLine2.topAnchor, constant: -10),

            quoteTweetWithBtn.leadingAnchor.constraint(equalTo: retweetsWithBtn.trailingAnchor, constant: 10),
            quoteTweetWithBtn.heightAnchor.constraint(equalToConstant: 25),
            quoteTweetWithBtn.bottomAnchor.constraint(equalTo: dividerLine2.topAnchor, constant: -10),

            tweetLikedWithBtn.leadingAnchor.constraint(equalTo: quoteTweetWithBtn.trailingAnchor, constant: 10),
            tweetLikedWithBtn.heightAnchor.constraint(equalToConstant: 25),
            tweetLikedWithBtn.bottomAnchor.constraint(equalTo: dividerLine2.topAnchor, constant: -10),

            dividerLine2.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 20),
            dividerLine2.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -20),
            dividerLine2.heightAnchor.constraint(equalToConstant: 0.7),
            dividerLine2.bottomAnchor.constraint(equalTo: stackView.topAnchor, constant: -5),

            stackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            stackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            stackView.heightAnchor.constraint(equalToConstant: 35),
            stackView.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -5)
        ])
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func setMetricDataAttribute(_ metricType:String , _ metricData:String) -> NSAttributedString{
        let attributedText = NSMutableAttributedString(string:"\(metricData)" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontMedium, size: 15)!,NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)])

        attributedText.append(NSAttributedString(string: " \(metricType)" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFont, size: 15)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))

        return attributedText
    }
    
    func manageData(){
        guard let data = data else {return}
        userInfo.attributedText = setTweetDetailUserInfoAttributes(data.user.name, data.user.screenName, data.user.isVerified)
        createdAt.text = data.createdAt.parseTwitterDate()
        profileImageView.cacheImageWithLoader(withURL: data.user.profileImage, view: profileLoaderView)
        tweet.text = data.text
        
        let retweetCount = "\(data.retweetCount ?? 0)"
        let retweetAttributedText = setMetricDataAttribute("Retweets", Double(retweetCount)!.kmFormatted)
        retweetsWithBtn.setAttributedTitle(retweetAttributedText, for: .normal)
        
        let likeCount = "\(data.favoriteCount ?? 0)"
        let likeAttributedText = setMetricDataAttribute("Likes", Double(likeCount)!.kmFormatted)
        tweetLikedWithBtn.setAttributedTitle(likeAttributedText, for: .normal)
        
        if data.favorited {
            likeBtn.setImage(UIImage(named: "favorited"), for: .normal)
        } else {
            likeBtn.setImage(UIImage(named: "heart"), for: .normal)
        }
        
//        if data.isRetweetedStatus {
//            retweetedProfileImage.isHidden = false
//            retweetImageView.isHidden = false
//            retweetedProfileImage.cacheImageWithLoader(withURL: data.retweetedBy.userProfileImage, view: userBackImageView)
//        } else {
//            retweetedProfileImage.isHidden = true
//            retweetImageView.isHidden = true
//        }
    }

}

extension TDPostWithImagesCollectionViewCell:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return (data?.media.count)!
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ImageCollectionViewCell", for: indexPath) as! ImageCollectionViewCell
        if let data = data {
            cell.data = data.media[indexPath.row]
        }
        return cell
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if (data?.media.count) == 1 {
          return CGSize(width: collectionView.frame.width, height: collectionView.frame.height)
        }
        if (data?.media.count) == 2 {
          return CGSize(width: ((collectionView.frame.width / 2) - 1), height: collectionView.frame.height)
        }
        if (data?.media.count) == 3 {
            if indexPath.row == 0 {
                return CGSize(width: collectionView.frame.width, height: (collectionView.frame.height / 2) - 1)
            }
            return CGSize(width: ((collectionView.frame.width / 2) - 1), height: ((collectionView.frame.height / 2) - 1))
        }
        if (data?.media.count) == 4{
            return CGSize(width: ((collectionView.frame.width / 2) - 1), height: ((collectionView.frame.height / 2) - 1))
        }
        return CGSize()
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.didImageTapped(for: self, indexPath.row)
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return 2
    }
    
}

extension TDPostWithImagesCollectionViewCell {
    
    @objc func userProfileSelected(){
        delegate?.didUserProfileTapped(for: self, false)
    }
    
//    @objc func retweetedProfileSelected(){
//       delegate?.didUserProfileTapped(for: self , true)
//    }
    
}
