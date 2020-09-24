//
//   Structures.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation

struct SimpleTextedPost {
    let profileImage:String!
    let name:String!
    let screen_name:String!
    let isVerified:Bool!
    let time:String!
    let media:[String]!
    
    let tweet:String!
    let comments:String!
    let retweets:String!
    let likes:String!
    let isQuotedView:Bool!
    let quotedStatus:QuotedStatus!
    
}

struct QuotedStatus {
    let profileImage:String!
    let name:String!
    let screen_name:String!
    let time:String!
    let isVerified:Bool!
    let tweet:String!
    let media:[String]!
}

//

struct TweetQuotedStatus {
    let createdAt:String!
    let user:TweetUser!
    let text:String!
    let media:[String]!
}

struct TweetUser {
    let userId:String!
    let name:String!
    let screenName:String!
    let profileImage:String!
    let isVerified:Bool!
}

struct TweetData {
    let createdAt:String!
    let id:String!
    let text:String!
    let user:TweetUser!
    let media:[String]!
    let isQuotedStatus:Bool!
    let tweetQuotedStatus:TweetQuotedStatus!
    let retweetCount:Int!
    let favoriteCount:Int!
    let favorited:Bool!
    let retweeted:Bool!
}
