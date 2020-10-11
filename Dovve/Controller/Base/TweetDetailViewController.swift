//
//  TweetDetailViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 29/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class TweetDetailViewController: UIViewController {

    var dataModel:GetTweetWithIdModel?
    var dataList:[TweetData]?
    var tweetId = ""
    
    lazy var collectionView:UICollectionView = {
        let layout:UICollectionViewFlowLayout = UICollectionViewFlowLayout.init()
        layout.scrollDirection = .vertical
        let cv = UICollectionView(frame: CGRect.zero, collectionViewLayout: UICollectionViewLayout.init())
//        cv.refreshControl = refresher
        cv.translatesAutoresizingMaskIntoConstraints = false
        cv.showsVerticalScrollIndicator = false
        cv.register(TDSimpleTextPostCollectionViewCell.self, forCellWithReuseIdentifier: "TDSimpleTextPostCollectionViewCell")
        cv.register(TDPostWithImagesCollectionViewCell.self, forCellWithReuseIdentifier: "TDPostWithImagesCollectionViewCell")
        cv.register(TDQuotedPostCollectionViewCell.self, forCellWithReuseIdentifier: "TDQuotedPostCollectionViewCell")
        cv.register(TDQuotedPostWithImageCollectionViewCell.self, forCellWithReuseIdentifier: "TDQuotedPostWithImageCollectionViewCell")
        cv.register(TDPostWithImageAndQuoteCollectionViewCell.self, forCellWithReuseIdentifier: "TDPostWithImageAndQuoteCollectionViewCell")
        cv.register(TDPostWithImageAndQuotedImageCollectionViewCell.self, forCellWithReuseIdentifier: "TDPostWithImageAndQuotedImageCollectionViewCell")
        cv.setCollectionViewLayout(layout, animated: false)
        cv.delegate = self
        cv.dataSource = self
        cv.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return cv
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        view.addSubview(collectionView)
        collectionView.pin(to: view)
        
        GetTweetWithIdModel.fetchTweetWithId(view: self, tweet_id: tweetId) { (dataModel) in
            self.dataModel = dataModel
            self.getDataListArray(dataModel)
            self.collectionView.reloadData()
        }
    }
    
    func getDataListArray(_ data:GetTweetWithIdModel){
        var tweets = [TweetData]()
        var mediaData = [TweetMediaData]()
        var quotedMediaData = [TweetMediaData]()
        
        if data.mediaData != nil {
            for j in 0..<data.mediaData.count {
                let media = TweetMediaData(imgURL:data.mediaData[j].imgUrl, vidURL: data.mediaData[j].vidUrl, duration: data.mediaData[j].duration,isVideo: data.isVideo)
                mediaData.append(media)
            }
        } else {
            mediaData = []
        }
        if data.isQuotedStatus == true {
            if data.quotedStatus.mediaData != nil {
                for j in 0..<data.quotedStatus.mediaData.count {
                    let media = TweetMediaData(imgURL:data.quotedStatus.mediaData[j].imgUrl, vidURL: data.quotedStatus.mediaData[j].vidUrl, duration: data.quotedStatus.mediaData[j].duration, isVideo: data.quotedStatus.isVideo)
                    quotedMediaData.append(media)
                }
            } else {
                quotedMediaData = []
            }
            if data.isRetweetedStatus == true {
                let tweet = TweetData(createdAt: data.createdAt, id: data.id, text: data.text, user: TweetUser(userId: data.user.userId, name: data.user.name, screenName: data.user.screen_name, profileImage: data.user.profileImage, isVerified: data.user.isVerified), media: mediaData , isVideo: data.isVideo,isRetweetedStatus: true, retweetedBy: TweetRetweetedData(userProfileImage: data.retweetedBy.userProfileImage, userID: data.retweetedBy.userID) ,isQuotedStatus: data.isQuotedStatus, tweetQuotedStatus:TweetQuotedStatus(createdAt: data.quotedStatus.createdAt, user: TweetUser(userId: data.quotedStatus.user.userId, name: data.quotedStatus.user.name, screenName: data.quotedStatus.user.screen_name, profileImage: data.quotedStatus.user.profileImage, isVerified: data.quotedStatus.user.isVerified), text: data.quotedStatus.text, media: quotedMediaData, isVideo: data.quotedStatus.isVideo), retweetCount: data.retweetCount, favoriteCount: data.favoriteCount, favorited: data.favorited, retweeted: data.retweeted, inReplyToStatusId: data.inReplyToStatusId)
                tweets.append(tweet)
            } else {
                let tweet = TweetData(createdAt: data.createdAt, id: data.id, text: data.text, user: TweetUser(userId: data.user.userId, name: data.user.name, screenName: data.user.screen_name, profileImage: data.user.profileImage, isVerified: data.user.isVerified), media: mediaData, isVideo: data.isVideo,isRetweetedStatus: false , retweetedBy: nil , isQuotedStatus: data.isQuotedStatus, tweetQuotedStatus:TweetQuotedStatus(createdAt: data.quotedStatus.createdAt, user: TweetUser(userId: data.quotedStatus.user.userId, name: data.quotedStatus.user.name, screenName: data.quotedStatus.user.screen_name, profileImage: data.quotedStatus.user.profileImage, isVerified: data.quotedStatus.user.isVerified), text: data.quotedStatus.text, media: quotedMediaData, isVideo: data.quotedStatus.isVideo), retweetCount: data.retweetCount, favoriteCount: data.favoriteCount, favorited: data.favorited, retweeted: data.retweeted, inReplyToStatusId: data.inReplyToStatusId)
                tweets.append(tweet)
            }
        } else {
            if data.isRetweetedStatus == true {
                let tweet = TweetData(createdAt: data.createdAt, id: data.id, text: data.text, user: TweetUser(userId: data.user.userId, name: data.user.name, screenName: data.user.screen_name, profileImage: data.user.profileImage, isVerified: data.user.isVerified), media: mediaData, isVideo: data.isVideo,isRetweetedStatus: true , retweetedBy: TweetRetweetedData(userProfileImage: data.retweetedBy.userProfileImage, userID: data.retweetedBy.userID), isQuotedStatus: data.isQuotedStatus, tweetQuotedStatus:nil, retweetCount: data.retweetCount, favoriteCount: data.favoriteCount, favorited: data.favorited, retweeted: data.retweeted, inReplyToStatusId: data.inReplyToStatusId)
                tweets.append(tweet)
            } else {
                let tweet = TweetData(createdAt: data.createdAt, id: data.id, text: data.text, user: TweetUser(userId: data.user.userId, name: data.user.name, screenName: data.user.screen_name, profileImage: data.user.profileImage, isVerified: data.user.isVerified), media: mediaData, isVideo: data.isVideo,isRetweetedStatus: false, retweetedBy: nil ,isQuotedStatus: data.isQuotedStatus, tweetQuotedStatus:nil, retweetCount: data.retweetCount, favoriteCount: data.favoriteCount, favorited: data.favorited, retweeted: data.retweeted, inReplyToStatusId: data.inReplyToStatusId)
                tweets.append(tweet)
            }
        }
        if dataList == nil {
            dataList = tweets
        } else {
            dataList?.append(contentsOf: tweets)
        }
    }
    
}

extension TweetDetailViewController:UICollectionViewDelegate, UICollectionViewDelegateFlowLayout, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if let dataList = dataList {
            return dataList.count
        }
        return Int()
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if let dataList = dataList {
            if indexPath.row == 0 {
                if dataList[indexPath.row].media == [] && dataList[indexPath.row].isQuotedStatus == false {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDSimpleTextPostCollectionViewCell", for: indexPath) as! TDSimpleTextPostCollectionViewCell
                    cell.data = dataList[indexPath.row]
                    return cell
                }
                if dataList[indexPath.row].media != [] &&  dataList[indexPath.row].isQuotedStatus == false {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDPostWithImagesCollectionViewCell", for: indexPath) as! TDPostWithImagesCollectionViewCell
                    cell.data = dataList[indexPath.row]
                    return cell
                }
                if dataList[indexPath.row].media == [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media == [] {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDQuotedPostCollectionViewCell", for: indexPath) as! TDQuotedPostCollectionViewCell
                    cell.data = dataList[indexPath.row]
                    return cell
                }
                if dataList[indexPath.row].media == [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media != [] {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDQuotedPostWithImageCollectionViewCell", for: indexPath) as! TDQuotedPostWithImageCollectionViewCell
                    cell.data = dataList[indexPath.row]
                    return cell
                }
                if dataList[indexPath.row].media != [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media == [] {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDPostWithImageAndQuoteCollectionViewCell", for: indexPath) as! TDPostWithImageAndQuoteCollectionViewCell
                    cell.data = dataList[indexPath.row]
                    return cell
                }
                if dataList[indexPath.row].media != [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media != [] {
                    let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "TDPostWithImageAndQuotedImageCollectionViewCell", for: indexPath) as! TDPostWithImageAndQuotedImageCollectionViewCell
                    cell.data = dataList[indexPath.row]
                    return cell
                }
            }
        }
        return UICollectionViewCell()
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if let dataList = dataList {
            if indexPath.row == 0 {
                if dataList[indexPath.row].media == [] && dataList[indexPath.row].isQuotedStatus == false {
                    let font = UIFont(name: CustomFonts.appFontThin, size: 20)!
                    let width = CGFloat(collectionView.frame.width - 40)
                    let estimatedH = dataList[indexPath.row].text.height(withWidth: width, font: font)
                    return CGSize(width: collectionView.frame.width, height: 210 + estimatedH)
                }
                if dataList[indexPath.row].media != [] &&  dataList[indexPath.row].isQuotedStatus == false {
                    let font = UIFont(name: CustomFonts.appFontThin, size: 20)!
                    let width = CGFloat(collectionView.frame.width - 40)
                    let estimatedH = dataList[indexPath.row].text.height(withWidth: width, font: font)
                    let extraHeight = 220 + (width * (9 / 16))
                    return CGSize(width: collectionView.frame.width, height: estimatedH + extraHeight )
                }
                if dataList[indexPath.row].media == [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media == [] {
                    let font = UIFont(name: CustomFonts.appFontThin, size: 20)!
                    let font2 = UIFont(name: CustomFonts.appFont, size: 17)!
                    let width = CGFloat(collectionView.frame.width - 40)
                    let estimatedH = dataList[indexPath.row].text.height(withWidth: width, font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row].tweetQuotedStatus.text.height(withWidth: (width - 30), font: font2)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + 280)
                }
                if dataList[indexPath.row].media == [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media != [] {
                    let font = UIFont(name: CustomFonts.appFontThin, size: 20)!
                    let font2 = UIFont(name: CustomFonts.appFont, size: 17)!
                    let width = CGFloat(collectionView.frame.width - 40)
                    let estimatedH = dataList[indexPath.row].text.height(withWidth: width, font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row].tweetQuotedStatus.text.height(withWidth: (width - 30), font: font2)
                    let imageCollectionHeight = (width * (9/16))
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionHeight + 280)
                }
                if dataList[indexPath.row].media != [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media == [] {
                    let font = UIFont(name: CustomFonts.appFontThin, size: 20)!
                    let font2 = UIFont(name: CustomFonts.appFont, size: 17)!
                    let width = CGFloat(collectionView.frame.width - 40)
                    let estimatedH = dataList[indexPath.row].text.height(withWidth: width, font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row].tweetQuotedStatus.text.height(withWidth: (width - 30), font: font2)
                    let imageCollectionForPostH = width * (9/16)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionForPostH + 280)
                }
                if dataList[indexPath.row].media != [] && dataList[indexPath.row].isQuotedStatus == true && dataList[indexPath.row].tweetQuotedStatus.media != [] {
                    let font = UIFont(name: CustomFonts.appFontThin, size: 20)!
                    let font2 = UIFont(name: CustomFonts.appFont, size: 17)!
                    let width = CGFloat(collectionView.frame.width - 40)
                    let estimatedH = dataList[indexPath.row].text.height(withWidth: width, font: font)
                    let estimatedHForQuotedTweet = dataList[indexPath.row].tweetQuotedStatus.text.height(withWidth: (width - 30), font: font2)
                    let imageCollectionHeight = width * (9/16)
                    let imageCollectionForPostH = width * (9/16)
                    return CGSize(width: collectionView.frame.width, height: estimatedH + estimatedHForQuotedTweet + imageCollectionHeight + imageCollectionForPostH + 280)
                }
            }
            
        }
        return CGSize()
    }
    
}
