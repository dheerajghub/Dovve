//
//  GetTweetWithIdModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 29/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class GetTweetWithIdModel: NSObject {

    var createdAt:String!
    var id:String!
    var text:String!
    var user:User!
    var mediaData:[MediaData]!
    var isQuotedStatus:Bool!
    var isRetweetedStatus:Bool!
    var retweetedBy:RetweetedData!
    var quotedStatus:QuotedViewStatus!
    var retweetCount:Int!
    var favoriteCount:Int!
    var favorited:Bool!
    var retweeted:Bool!
    var isVideo:Bool!
    var inReplyToStatusId:String!

    static func fetchTweetWithId(view:UIViewController , tweet_id:String, completionHandler: @escaping (GetTweetWithIdModel) -> ()){
        let url = "\(Constants.BASE_URL.rawValue)/1.1/statuses/lookup.json?id=\(tweet_id)&tweet_mode=extended"

        let headers: HTTPHeaders = [
            "Authorization":"Bearer \(Constants.BEARER_TOKEN.rawValue)"
        ]
        let method: HTTPMethod = .get

        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                var data = JSON(response.value!)
                if data["errors"][0]["message"].string != nil {
                    view.showMessage(data["errors"][0]["message"].string ?? "", type: .error)
                } else {
                    data = data[0]
                    let tweetModel = GetTweetWithIdModel()
                    let retweetedStatus = data["retweeted_status"]["created_at"].string
                    if retweetedStatus == nil {
                        tweetModel.createdAt = data["created_at"].string ?? ""
                        tweetModel.id = data["id_str"].string ?? ""
                        tweetModel.text = data["full_text"].string ?? ""
                        
                        let user = User()
                        let userData = data["user"]
                        user.userId = userData["id_str"].string ?? ""
                        user.name = userData["name"].string ?? ""
                        user.screen_name = userData["screen_name"].string ?? ""
                        user.profileImage = userData["profile_image_url_https"].string ?? ""
                        user.isVerified = userData["verified"].bool
                        
                        tweetModel.user = user
                        let mediaData = data["extended_entities"]["media"].array
                        if mediaData == nil {
                            tweetModel.mediaData = nil
                        } else {
                            let mediaData = data["extended_entities"]["media"]
                            if mediaData[0]["type"].string == "photo" {
                                var mediaArr = [MediaData]()
                                for i in 0..<mediaData.count{
                                    let media = MediaData()
                                    media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                    media.duration = nil
                                    media.vidUrl = nil
                                    media.isVideo = false
                                    mediaArr.append(media)
                                }
                                tweetModel.mediaData = mediaArr
                                tweetModel.isVideo = false
                            } else {
                                var mediaArr = [MediaData]()
                                for i in 0..<mediaData.count{
                                    let media = MediaData()
                                    media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                    media.vidUrl = mediaData[i]["video_info"]["variants"][0]["url"].string ?? ""
                                    media.duration = mediaData[i]["video_info"]["duration_millis"].int
                                    media.isVideo = true
                                    mediaArr.append(media)
                                }
                                tweetModel.mediaData = mediaArr
                                tweetModel.isVideo = true
                            }
                        }
                        
                        tweetModel.isRetweetedStatus = false
                        tweetModel.retweetedBy = nil
                        if data["is_quote_status"] == true {
                            let quoteView = QuotedViewStatus()
                            let quoteData = data["quoted_status"]
                            if quoteData["created_at"].string != nil {
                                tweetModel.isQuotedStatus = data["is_quote_status"].bool
                                quoteView.createdAt = quoteData["created_at"].string ?? ""
                                
                                let mediaData = quoteData["extended_entities"]["media"].array
                                if mediaData == nil {
                                    quoteView.mediaData = nil
                                } else {
                                    let mediaData = quoteData["extended_entities"]["media"]
                                    if mediaData[0]["type"].string == "photo" {
                                        var mediaArr = [MediaData]()
                                        for i in 0..<mediaData.count{
                                            let media = MediaData()
                                            media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                            media.duration = nil
                                            media.vidUrl = nil
                                            media.isVideo = false
                                            mediaArr.append(media)
                                        }
                                        quoteView.mediaData = mediaArr
                                        quoteView.isVideo = false
                                    } else {
                                        var mediaArr = [MediaData]()
                                        for i in 0..<mediaData.count{
                                            let media = MediaData()
                                            media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                            media.vidUrl = mediaData[i]["video_info"]["variants"][0]["url"].string ?? ""
                                            media.duration = mediaData[i]["video_info"]["duration_millis"].int
                                            media.isVideo = true
                                            mediaArr.append(media)
                                        }
                                        quoteView.mediaData = mediaArr
                                        quoteView.isVideo = true
                                    }
                                }
                                quoteView.text = quoteData["full_text"].string ?? ""
                                
                                let quotedUser = User()
                                let quotedUserData = quoteData["user"]
                                quotedUser.userId = quotedUserData["id_str"].string ?? ""
                                quotedUser.name = quotedUserData["name"].string ?? ""
                                quotedUser.screen_name = quotedUserData["screen_name"].string ?? ""
                                quotedUser.profileImage = quotedUserData["profile_image_url_https"].string ?? ""
                                quotedUser.isVerified = quotedUserData["verified"].bool
                                
                                quoteView.user = quotedUser
                                tweetModel.quotedStatus = quoteView
                            } else {
                                tweetModel.isQuotedStatus = false
                                tweetModel.quotedStatus = nil
                            }
                            
                        } else {
                            tweetModel.isQuotedStatus = false
                            tweetModel.quotedStatus = nil
                        }
                        tweetModel.retweetCount = data["retweet_count"].int
                        tweetModel.favoriteCount = data["favorite_count"].int
                        tweetModel.favorited = data["favorited"].bool
                        tweetModel.retweeted = data["retweeted"].bool
                    } else {
                        let retweetedData = data["retweeted_status"]
                            tweetModel.createdAt = retweetedData["created_at"].string ?? ""
                            tweetModel.id = retweetedData["id_str"].string ?? ""
                            tweetModel.text = retweetedData["full_text"].string ?? ""
                            let user = User()
                            let userData = retweetedData["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            tweetModel.user = user
                            let mediaData = data["extended_entities"]["media"].array
                            if mediaData == nil {
                                tweetModel.mediaData = nil
                            } else {
                                let mediaData = data["extended_entities"]["media"]
                                if mediaData[0]["type"].string == "photo" {
                                    var mediaArr = [MediaData]()
                                    for i in 0..<mediaData.count{
                                        let media = MediaData()
                                        media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                        media.duration = nil
                                        media.vidUrl = nil
                                        media.isVideo = false
                                        mediaArr.append(media)
                                    }
                                    tweetModel.mediaData = mediaArr
                                    tweetModel.isVideo = false
                                } else {
                                    var mediaArr = [MediaData]()
                                    for i in 0..<mediaData.count{
                                        let media = MediaData()
                                        media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                        media.vidUrl = mediaData[i]["video_info"]["variants"][0]["url"].string ?? ""
                                        media.duration = mediaData[i]["video_info"]["duration_millis"].int
                                        media.isVideo = true
                                        mediaArr.append(media)
                                    }
                                    tweetModel.mediaData = mediaArr
                                    tweetModel.isVideo = true
                                }
                            }
                            
                            tweetModel.isRetweetedStatus = true
                            let retweetedByUserData = RetweetedData()
                            retweetedByUserData.userID = data["user"]["id_str"].string
                            retweetedByUserData.userProfileImage = data["user"]["profile_image_url_https"].string
                            tweetModel.retweetedBy = retweetedByUserData
                            if retweetedData["is_quote_status"] == true {
                                
                                let quoteView = QuotedViewStatus()
                                let quoteData = retweetedData["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    tweetModel.isQuotedStatus = retweetedData["is_quote_status"].bool
                                    quoteView.createdAt = quoteData["created_at"].string ?? ""
                                    
                                    let mediaData = quoteData["extended_entities"]["media"].array
                                    if mediaData == nil {
                                        quoteView.mediaData = nil
                                    } else {
                                        let mediaData = quoteData["extended_entities"]["media"]
                                        if mediaData[0]["type"].string == "photo" {
                                            var mediaArr = [MediaData]()
                                            for i in 0..<mediaData.count{
                                                let media = MediaData()
                                                media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                                media.duration = nil
                                                media.vidUrl = nil
                                                media.isVideo = false
                                                mediaArr.append(media)
                                            }
                                            quoteView.mediaData = mediaArr
                                            quoteView.isVideo = false
                                        } else {
                                            var mediaArr = [MediaData]()
                                            for i in 0..<mediaData.count{
                                                let media = MediaData()
                                                media.imgUrl = mediaData[i]["media_url_https"].string ?? ""
                                                media.vidUrl = mediaData[i]["video_info"]["variants"][0]["url"].string ?? ""
                                                media.duration = mediaData[i]["video_info"]["duration_millis"].int
                                                media.isVideo = true
                                                mediaArr.append(media)
                                            }
                                            quoteView.mediaData = mediaArr
                                            quoteView.isVideo = true
                                        }
                                    }
                                    quoteView.text = quoteData["full_text"].string ?? ""
                                    
                                    let quotedUser = User()
                                    let quotedUserData = quoteData["user"]
                                    quotedUser.userId = quotedUserData["id_str"].string ?? ""
                                    quotedUser.name = quotedUserData["name"].string ?? ""
                                    quotedUser.screen_name = quotedUserData["screen_name"].string ?? ""
                                    quotedUser.profileImage = quotedUserData["profile_image_url_https"].string ?? ""
                                    quotedUser.isVerified = quotedUserData["verified"].bool
                                    
                                    quoteView.user = quotedUser
                                    tweetModel.quotedStatus = quoteView
                                } else {
                                    tweetModel.isQuotedStatus = false
                                    tweetModel.quotedStatus = nil
                                }
                                
                            } else {
                                tweetModel.isQuotedStatus = false
                                tweetModel.quotedStatus = nil
                            }
                            tweetModel.retweetCount = data["retweet_count"].int
                            tweetModel.favoriteCount = data["favorite_count"].int
                            tweetModel.favorited = data["favorited"].bool
                            tweetModel.retweeted = data["retweeted"].bool
                        }
                    DispatchQueue.main.async {
                        completionHandler(tweetModel)
                    }
                }
                
            case .failure(_):
                print("error")
            }
        }
    }
}

