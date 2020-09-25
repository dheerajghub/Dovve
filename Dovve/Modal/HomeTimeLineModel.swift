//
//  HomeTimeLineModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 24/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class User {
    var userId:String!
    var name:String!
    var screen_name:String!
    var profileImage:String!
    var isVerified:Bool!
}

class QuotedViewStatus {
    var createdAt:String!
    var user:User!
    var text:String!
    var media:[String]!
}

class RetweetedData {
    var userProfileImage:String!
    var userID:String!
}

class HomeTimeLineModel:NSObject{
    
    var createdAt:String!
    var id:String!
    var text:String!
    var user:User!
    var media:[String]!
    var isQuotedStatus:Bool!
    var isRetweetedStatus:Bool!
    var retweetedBy:RetweetedData!
    var quotedStatus:QuotedViewStatus!
    var retweetCount:Int!
    var favoriteCount:Int!
    var favorited:Bool!
    var retweeted:Bool!
    
    static func fetchHometimeLine(view:UIViewController , max_id:String, params:String , completionHandler: @escaping ([HomeTimeLineModel]) -> ()){
        
        let url = "\(Constants.BASE_URL.rawValue)/1.1/statuses/home_timeline.json?tweet_mode=extended\(params)"
        let urlS = "\(Constants.BASE_URL.rawValue)/1.1/statuses/home_timeline.json"
        let authToken: String? = KeychainWrapper.standard.string(forKey: "authToken")
        let authTokenSecret:String? = KeychainWrapper.standard.string(forKey: "authTokenSecret")
        let model = TwitterSignatureParameters(
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
                    var homeTimeLineModel = [HomeTimeLineModel]()
                    let dataCount = data.count
                    for i in 0..<dataCount{
                        let homeModel = HomeTimeLineModel()
                        let retweetedStatus = data[i]["retweeted_status"]["created_at"].string
                        if retweetedStatus == nil {
                            homeModel.createdAt = data[i]["created_at"].string ?? ""
                            homeModel.id = data[i]["id_str"].string ?? ""
                            homeModel.text = data[i]["full_text"].string ?? ""
                            
                            let user = User()
                            let userData = data[i]["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            homeModel.user = user
                            let mediaData = data[i]["extended_entities"]["media"].array
                            if mediaData == nil {
                                homeModel.media = nil
                            } else {
                                let mediaData = data[i]["extended_entities"]["media"]
                                var mediaArr = [String]()
                                for i in 0..<mediaData.count{
                                    mediaArr.append(mediaData[i]["media_url_https"].string ?? "")
                                }
                                homeModel.media = mediaArr
                            }
                            
                            homeModel.isRetweetedStatus = false
                            homeModel.retweetedBy = nil
                            if data[i]["is_quote_status"] == true {
                                let quoteView = QuotedViewStatus()
                                let quoteData = data[i]["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    homeModel.isQuotedStatus = data[i]["is_quote_status"].bool
                                    quoteView.createdAt = quoteData["created_at"].string ?? ""
                                    
                                    let mediaData = quoteData["extended_entities"]["media"].array
                                    if mediaData == nil {
                                        quoteView.media = nil
                                    } else {
                                        let mediaData = quoteData["extended_entities"]["media"]
                                        var mediaArr = [String]()
                                        for i in 0..<mediaData.count{
                                            mediaArr.append(mediaData[i]["media_url_https"].string ?? "")
                                        }
                                        quoteView.media = mediaArr
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
                                    homeModel.quotedStatus = quoteView
                                } else {
                                    homeModel.isQuotedStatus = false
                                    homeModel.quotedStatus = nil
                                }
                                
                            } else {
                                homeModel.isQuotedStatus = false
                                homeModel.quotedStatus = nil
                            }
                            homeModel.retweetCount = data[i]["retweet_count"].int
                            homeModel.favoriteCount = data[i]["favorite_count"].int
                            homeModel.favorited = data[i]["favorited"].bool
                            homeModel.retweeted = data[i]["retweeted"].bool
                            
                            homeTimeLineModel.append(homeModel)
                            
                        } else {
                            
                            let retweetedData = data[i]["retweeted_status"]
                            homeModel.createdAt = retweetedData["created_at"].string ?? ""
                            homeModel.id = retweetedData["id_str"].string ?? ""
                            homeModel.text = retweetedData["full_text"].string ?? ""
                            let user = User()
                            let userData = retweetedData["user"]
                            user.userId = userData["id_str"].string ?? ""
                            user.name = userData["name"].string ?? ""
                            user.screen_name = userData["screen_name"].string ?? ""
                            user.profileImage = userData["profile_image_url_https"].string ?? ""
                            user.isVerified = userData["verified"].bool
                            
                            homeModel.user = user
                            let mediaData = data[i]["extended_entities"]["media"].array
                            if mediaData == nil {
                                homeModel.media = nil
                            } else {
                                let mediaData = data[i]["extended_entities"]["media"]
                                var mediaArr = [String]()
                                for i in 0..<mediaData.count{
                                    mediaArr.append(mediaData[i]["media_url_https"].string ?? "")
                                }
                                homeModel.media = mediaArr
                            }
                            
                            homeModel.isRetweetedStatus = true
                            let retweetedByUserData = RetweetedData()
                            retweetedByUserData.userID = data[i]["user"]["id_str"].string
                            retweetedByUserData.userProfileImage = data[i]["user"]["profile_image_url_https"].string
                            homeModel.retweetedBy = retweetedByUserData
                            if retweetedData["is_quote_status"] == true {
                                
                                let quoteView = QuotedViewStatus()
                                let quoteData = retweetedData["quoted_status"]
                                if quoteData["created_at"].string != nil {
                                    homeModel.isQuotedStatus = retweetedData["is_quote_status"].bool
                                    quoteView.createdAt = quoteData["created_at"].string ?? ""
                                    
                                    let mediaData = quoteData["extended_entities"]["media"].array
                                    if mediaData == nil {
                                        quoteView.media = nil
                                    } else {
                                        let mediaData = quoteData["extended_entities"]["media"]
                                        var mediaArr = [String]()
                                        for i in 0..<mediaData.count{
                                            mediaArr.append(mediaData[i]["media_url_https"].string ?? "")
                                        }
                                        quoteView.media = mediaArr
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
                                    homeModel.quotedStatus = quoteView
                                } else {
                                    homeModel.isQuotedStatus = false
                                    homeModel.quotedStatus = nil
                                }
                                
                            } else {
                                homeModel.isQuotedStatus = false
                                homeModel.quotedStatus = nil
                            }
                            homeModel.retweetCount = data[i]["retweet_count"].int
                            homeModel.favoriteCount = data[i]["favorite_count"].int
                            homeModel.favorited = data[i]["favorited"].bool
                            homeModel.retweeted = data[i]["retweeted"].bool
                            
                            homeTimeLineModel.append(homeModel)
                        }
                    }
                    DispatchQueue.main.async {
                        completionHandler(homeTimeLineModel)
                    }
                }
                
            case .failure(_):
                print("error")
            }
        }
        
    }
}
