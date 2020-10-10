//
//   Structures.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation

struct TweetMediaData:Equatable {
    let imgURL:String!
    let vidURL:String!
    let duration:Int!
    let isVideo:Bool!
}

struct TweetQuotedStatus {
    let createdAt:String!
    let user:TweetUser!
    let text:String!
    let media:[TweetMediaData]!
    let isVideo:Bool!
}

struct TweetUser {
    let userId:String!
    let name:String!
    let screenName:String!
    let profileImage:String!
    let isVerified:Bool!
}

struct TweetRetweetedData {
    var userProfileImage:String!
    var userID:String!
}

struct TweetData {
    let createdAt:String!
    let id:String!
    let text:String!
    let user:TweetUser!
    let media:[TweetMediaData]!
    let isVideo:Bool!
    let isRetweetedStatus:Bool!
    let retweetedBy:TweetRetweetedData!
    let isQuotedStatus:Bool!
    let tweetQuotedStatus:TweetQuotedStatus!
    let retweetCount:Int!
    let favoriteCount:Int!
    let favorited:Bool!
    let retweeted:Bool!
    let inReplyToStatusId:String!
}

struct UserProfile {
    let id:String!
    let name:String!
    let screenName:String!
    let bio:String!
    let followers:Int!
    let friends:Int!
    let joiningDate:String!
    let tweetCount:Int!
    let isVerified:Bool!
    let profileImage:String!
    let backgroundImage:String!
    let website:String!
}

struct FollowDetail {
    let id:String!
    let name:String!
    let screenName:String!
    let bio:String!
    let isVerified:Bool!
    let profileImage:String!
}
