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

class HomeTimeLineModel:NSObject{
    
    var createdAt:String!
    var id:String!
    var text:String!
    var user:User!
    var media:[String]!
    var isQuotedStatus:Bool!
    var quotedStatus:QuotedViewStatus!
    var retweetCount:Int!
    var favoriteCount:Int!
    var favorited:Bool!
    var retweeted:Bool!
    
    static func fetchHometimeLine(completionHandler: @escaping ([HomeTimeLineModel]) -> ()){
        
        let url = "\(Constants.BASE_URL.rawValue)/1.1/statuses/home_timeline.json?tweet_mode=extended"
        let urlS = "\(Constants.BASE_URL.rawValue)/1.1/statuses/home_timeline.json"
//        let url = "https://bb08dc8de14dbb0fda369a65b0aa4650.m.pipedream.net?tweet_mode=extended"
        let authToken: String? = KeychainWrapper.standard.string(forKey: "authToken")
        let authTokenSecret:String? = KeychainWrapper.standard.string(forKey: "authTokenSecret")
        
        let model = TwitterSignatureParameters(
            includeEntities: true,
            oauthConsumerKey:  Constants.CONSUMER_KEY.rawValue,
            oauthSignatureMethod: "HMAC-SHA1",
            oauthTimestamp: "\(Int(Date().timeIntervalSince1970))",
            oauthToken: authToken!,
            oauthVersion: "1.0",
            oauthNonce: "\(UUID().uuidString)",
            urlString: urlS,
            params: "&tweet_mode=extended"
//            params:""
        )
        
        let twitterOAuth = TwitterSwiftLite()
        let headers = twitterOAuth.makeHeaders(model, Constants.CONSUMER_SECRET.rawValue, authTokenSecret!)
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                var homeTimeLineModel = [HomeTimeLineModel]()
                let dataCount = data.count
                for i in 0..<dataCount{
                    let homeModel = HomeTimeLineModel()
                    homeModel.createdAt = data[i]["created_at"].string ?? ""
                    homeModel.id = data[i]["id_str"].string ?? ""
                    homeModel.text = data[i]["full_text"].string ?? ""
                    
                    let user = User()
                    let userData = data[i]["user"]
                    user.userId = userData["id_str"].string ?? ""
                    user.name = userData["name"].string ?? ""
                    user.screen_name = userData["screen_name"].string ?? ""
                    user.profileImage = userData["profile_image_url_https"].string ?? ""
                    //Default verification
                    user.isVerified = false
                    
                    homeModel.user = user
                    let mediaData = data[i]["entities"]["media"].array
                    if mediaData == nil {
                        homeModel.media = nil
                    } else {
                        let mediaData = data[i]["entities"]["media"]
                        var mediaArr = [String]()
                        for i in 0..<mediaData.count{
                            mediaArr.append(mediaData[i]["media_url_https"].string ?? "")
                        }
                        homeModel.media = mediaArr
                    }
                    
                    homeModel.isQuotedStatus = data[i]["is_quote_status"].bool
                    if data[i]["is_quote_status"] == true {
                        let quoteView = QuotedViewStatus()
                        let quoteData = data[i]["quoted_status"]
                        quoteView.createdAt = quoteData["created_at"].string ?? ""
                        
                        let mediaData = quoteData["entities"]["media"].array
                        if mediaData == nil {
                            quoteView.media = nil
                        } else {
                            let mediaData = quoteData["entities"]["media"]
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
                        //Default verification
                        quotedUser.isVerified = false
                        
                        quoteView.user = quotedUser
                        homeModel.quotedStatus = quoteView
                    } else {
                        homeModel.quotedStatus = nil
                    }
                    homeModel.retweetCount = data[i]["retweet_count"].int
                    homeModel.favoriteCount = data[i]["favorite_count"].int
                    homeModel.favorited = data[i]["favorited"].bool
                    homeModel.retweeted = data[i]["retweeted"].bool
                    
                    homeTimeLineModel.append(homeModel)
                }
                
                DispatchQueue.main.async {
                    completionHandler(homeTimeLineModel)
                }
                
            case .failure(_):
                print("error")
            }
        }
        
    }
}
