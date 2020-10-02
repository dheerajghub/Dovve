//
//  SearchModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 01/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class SearchModel:NSObject{
    
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
    
    static func fetchSearchModel(view:UIViewController, params:String , completionHandler: @escaping ([SearchModel]) -> ()){
        
        let url = "\(Constants.BASE_URL.rawValue)/1.1/search/tweets.json?tweet_mode=extended\(params)"
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
                    data = data["statuses"]
                    var SearchListModel = [SearchModel]()
                    let dataCount = data.count
                    for i in 0..<dataCount{
                        let searchModel = SearchModel()
                        let retweetedStatus = data[i]["retweeted_status"]["created_at"].string
                        if retweetedStatus == nil {
                            searchModel.createdAt = data[i]["created_at"].string ?? ""
                            searchModel.id = data[i]["id_str"].string ?? ""
                            searchModel.text = data[i]["full_text"].string ?? ""
                            
                            let user = User()
                            let userData = data[i]["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            searchModel.user = user
                            let mediaData = data[i]["extended_entities"]["media"].array
                            if mediaData == nil {
                                searchModel.mediaData = nil
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
                                    searchModel.mediaData = mediaArr
                                    searchModel.isVideo = false
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
                                    searchModel.mediaData = mediaArr
                                    searchModel.isVideo = true
                                }
                            }
                            
                            searchModel.isRetweetedStatus = false
                            searchModel.retweetedBy = nil
                            if data[i]["is_quote_status"] == true {
                                let quoteView = QuotedViewStatus()
                                let quoteData = data[i]["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    searchModel.isQuotedStatus = data[i]["is_quote_status"].bool
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
                                    searchModel.quotedStatus = quoteView
                                } else {
                                    searchModel.isQuotedStatus = false
                                    searchModel.quotedStatus = nil
                                }
                                
                            } else {
                                searchModel.isQuotedStatus = false
                                searchModel.quotedStatus = nil
                            }
                            searchModel.retweetCount = data[i]["retweet_count"].int
                            searchModel.favoriteCount = data[i]["favorite_count"].int
                            searchModel.favorited = data[i]["favorited"].bool
                            searchModel.retweeted = data[i]["retweeted"].bool
                            
                            SearchListModel.append(searchModel)
                            
                        } else {
                            
                            let retweetedData = data[i]["retweeted_status"]
                            searchModel.createdAt = retweetedData["created_at"].string ?? ""
                            searchModel.id = retweetedData["id_str"].string ?? ""
                            searchModel.text = retweetedData["full_text"].string ?? ""
                            let user = User()
                            let userData = retweetedData["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            searchModel.user = user
                            let mediaData = data[i]["extended_entities"]["media"].array
                            if mediaData == nil {
                                searchModel.mediaData = nil
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
                                    searchModel.mediaData = mediaArr
                                    searchModel.isVideo = false
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
                                    searchModel.mediaData = mediaArr
                                    searchModel.isVideo = true
                                }
                            }
                            
                            searchModel.isRetweetedStatus = true
                            let retweetedByUserData = RetweetedData()
                            retweetedByUserData.userID = data[i]["user"]["id_str"].string
                            retweetedByUserData.userProfileImage = data[i]["user"]["profile_image_url_https"].string
                            searchModel.retweetedBy = retweetedByUserData
                            if retweetedData["is_quote_status"] == true {
                                
                                let quoteView = QuotedViewStatus()
                                let quoteData = retweetedData["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    searchModel.isQuotedStatus = retweetedData["is_quote_status"].bool
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
                                    searchModel.quotedStatus = quoteView
                                } else {
                                    searchModel.isQuotedStatus = false
                                    searchModel.quotedStatus = nil
                                }
                                
                            } else {
                                searchModel.isQuotedStatus = false
                                searchModel.quotedStatus = nil
                            }
                            searchModel.retweetCount = data[i]["retweet_count"].int
                            searchModel.favoriteCount = data[i]["favorite_count"].int
                            searchModel.favorited = data[i]["favorited"].bool
                            searchModel.retweeted = data[i]["retweeted"].bool
                            
                            SearchListModel.append(searchModel)
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(SearchListModel)
                    }
                }
                
            case .failure(_):
                print("error")
                view.showMessage("No Internet", type: .error)
            }
        }
        
    }
}
