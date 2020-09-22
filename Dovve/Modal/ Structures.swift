//
//   Structures.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 21/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation

struct SimpleTextedPost {
    
    //Must
    let profileImage:String!
    let name:String!
    let screen_name:String!
    let isVerified:Bool!
    let time:String!
    let media:[String]!
    
    //Extras
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
