//
//  MentionTimelineModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 07/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class MentionTimeLineModel:NSObject{
    
    var createdAt:String!
    var id:String!
    var text:String!
    var user:User!
    var mediaData:[MediaData]!
    var isVideo:Bool!
    var isQuotedStatus:Bool!
    var isRetweetedStatus:Bool!
    var retweetedBy:RetweetedData!
    var quotedStatus:QuotedViewStatus!
    var retweetCount:Int!
    var favoriteCount:Int!
    var favorited:Bool!
    var retweeted:Bool!
    
    static func fetchMentiontimeLine(view:UIViewController , max_id:String, params:String , completionHandler: @escaping ([MentionTimeLineModel]) -> ()){
        
        let url = "\(Constants.BASE_URL.rawValue)/1.1/statuses/mentions_timeline.json?tweet_mode=extended\(params)"
        let urlS = "\(Constants.BASE_URL.rawValue)/1.1/statuses/mentions_timeline.json"
        let authToken: String? = KeychainWrapper.standard.string(forKey: "authToken")
        let authTokenSecret:String? = KeychainWrapper.standard.string(forKey: "authTokenSecret")
        let model = TwitterSignatureParameters(
            user_id: "",
            max_id: "\(max_id)",
            oauthConsumerKey:  Constants.CONSUMER_KEY.rawValue,
            oauthSignatureMethod: "HMAC-SHA1",
            oauthTimestamp: "\(Int(Date().timeIntervalSince1970))",
            oauthToken: authToken!,
            oauthVersion: "1.0",
            oauthNonce: "\(UUID().uuidString)",
            urlString: urlS,
            params: "&tweet_mode=extended"
        )
        
        let twitterOAuth = TwitterSwiftLite()
        let headers = twitterOAuth.makeHeaders(model, Constants.CONSUMER_SECRET.rawValue, authTokenSecret!)
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                if data["errors"][0]["message"].string != nil {
                    view.showMessage(data["errors"][0]["message"].string ?? "", type: .error)
                } else {
                    var homeTimeLineModel = [MentionTimeLineModel]()
                    let dataCount = data.count
                    for i in 0..<dataCount{
                        let mentionModel = MentionTimeLineModel()
                        let retweetedStatus = data[i]["retweeted_status"]["created_at"].string
                        if retweetedStatus == nil {
                            mentionModel.createdAt = data[i]["created_at"].string ?? ""
                            mentionModel.id = data[i]["id_str"].string ?? ""
                            mentionModel.text = data[i]["full_text"].string ?? ""
                            
                            let user = User()
                            let userData = data[i]["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            mentionModel.user = user
                            let mediaData = data[i]["extended_entities"]["media"].array
                            if mediaData == nil {
                                mentionModel.mediaData = nil
                            } else {
                                let mediaData = data[i]["extended_entities"]["media"]
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
                                    mentionModel.mediaData = mediaArr
                                    mentionModel.isVideo = false
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
                                    mentionModel.mediaData = mediaArr
                                    mentionModel.isVideo = true
                                }
                            }
                            
                            mentionModel.isRetweetedStatus = false
                            mentionModel.retweetedBy = nil
                            if data[i]["is_quote_status"] == true {
                                let quoteView = QuotedViewStatus()
                                let quoteData = data[i]["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    mentionModel.isQuotedStatus = data[i]["is_quote_status"].bool
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
                                    mentionModel.quotedStatus = quoteView
                                } else {
                                    mentionModel.isQuotedStatus = false
                                    mentionModel.quotedStatus = nil
                                }
                                
                            } else {
                                mentionModel.isQuotedStatus = false
                                mentionModel.quotedStatus = nil
                            }
                            mentionModel.retweetCount = data[i]["retweet_count"].int
                            mentionModel.favoriteCount = data[i]["favorite_count"].int
                            mentionModel.favorited = data[i]["favorited"].bool
                            mentionModel.retweeted = data[i]["retweeted"].bool
                            
                            homeTimeLineModel.append(mentionModel)
                            
                        } else {
                            
                            let retweetedData = data[i]["retweeted_status"]
                            mentionModel.createdAt = retweetedData["created_at"].string ?? ""
                            mentionModel.id = retweetedData["id_str"].string ?? ""
                            mentionModel.text = retweetedData["full_text"].string ?? ""
                            let user = User()
                            let userData = retweetedData["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            mentionModel.user = user
                            let mediaData = data[i]["extended_entities"]["media"].array
                            if mediaData == nil {
                                mentionModel.mediaData = nil
                            } else {
                                let mediaData = data[i]["extended_entities"]["media"]
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
                                    mentionModel.mediaData = mediaArr
                                    mentionModel.isVideo = false
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
                                    mentionModel.mediaData = mediaArr
                                    mentionModel.isVideo = true
                                }
                            }
                            
                            mentionModel.isRetweetedStatus = true
                            let retweetedByUserData = RetweetedData()
                            retweetedByUserData.userID = data[i]["user"]["id_str"].string
                            retweetedByUserData.userProfileImage = data[i]["user"]["profile_image_url_https"].string
                            mentionModel.retweetedBy = retweetedByUserData
                            if retweetedData["is_quote_status"] == true {
                                
                                let quoteView = QuotedViewStatus()
                                let quoteData = retweetedData["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    mentionModel.isQuotedStatus = retweetedData["is_quote_status"].bool
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
                                    mentionModel.quotedStatus = quoteView
                                } else {
                                    mentionModel.isQuotedStatus = false
                                    mentionModel.quotedStatus = nil
                                }
                                
                            } else {
                                mentionModel.isQuotedStatus = false
                                mentionModel.quotedStatus = nil
                            }
                            mentionModel.retweetCount = data[i]["retweet_count"].int
                            mentionModel.favoriteCount = data[i]["favorite_count"].int
                            mentionModel.favorited = data[i]["favorited"].bool
                            mentionModel.retweeted = data[i]["retweeted"].bool
                            
                            homeTimeLineModel.append(mentionModel)
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(homeTimeLineModel)
                    }
                }
                
            case .failure(_):
                print("error")
                view.showMessage("No Internet", type: .error)
            }
        }
        
    }
}
