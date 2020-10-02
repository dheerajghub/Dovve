//
//  GetTweetWithIdModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 29/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

//import UIKit
//import Alamofire
//import SwiftyJSON
//import SwiftKeychainWrapper
//import GSMessages
//
//class GetTweetWithIdModel: NSObject {
//
//    var createdAt:String!
//    var id:String!
//    var text:String!
//    var user:User!
//    var media:[String]!
//    var isQuotedStatus:Bool!
//    var isRetweetedStatus:Bool!
//    var retweetedBy:RetweetedData!
//    var quotedStatus:QuotedViewStatus!
//    var retweetCount:Int!
//    var favoriteCount:Int!
//    var favorited:Bool!
//    var retweeted:Bool!
//
//    static func fetchFollowingStatus(tweet_id:String, completionHandler: @escaping (GetTweetWithIdModel) -> ()){
//        let url = "\(Constants.BASE_URL.rawValue)/1.1/statuses/lookup.json?id=\(tweet_id)"
//
//        let headers: HTTPHeaders = [
//            "Authorization":"Bearer \(Constants.BEARER_TOKEN.rawValue)"
//        ]
//        let method: HTTPMethod = .get
//
//        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
//            switch(response.result){
//            case .success(_):
//                let data = JSON(response.value!)
//                print(data)
//                let tweetModel = GetTweetWithIdModel()
//                tweetModel.createdAt = data["created_at"].string
//                tweetModel.id = data["id_str"].string
//                tweetModel.text = data["text"].string
//
//                let user = User()
//                let userData = data["user"]
//                user.userId = userData["id_str"].string ?? ""
//                user.name = userData["name"].string ?? ""
//                user.screen_name = userData["screen_name"].string ?? ""
//                user.profileImage = userData["profile_image_url_https"].string ?? ""
//                user.isVerified = userData["verified"].bool
//
//                tweetModel.user = user
//
//
//
//                DispatchQueue.main.async {
//                    completionHandler(tweetData)
//                }
//            case .failure(_):
//                print("error")
//            }
//        }
//    }
//}
//
