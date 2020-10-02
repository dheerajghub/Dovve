//
//  UserProfileModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 26/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class UserProfileModel:NSObject{
    
    var id:String!
    var name:String!
    var screenName:String!
    var bio:String!
    var followers:Int!
    var friends:Int!
    var joiningDate:String!
    var tweetCount:Int!
    var isVerified:Bool!
    var profileImage:String!
    var backgroundImage:String!
    var website:String!
    var isProtected:Bool!
    
    static func fetchUserProfile(view:UIViewController , params:String, completionHandler: @escaping (UserProfileModel) -> ()){
        let url = "\(Constants.BASE_URL.rawValue)/1.1/users/show.json?\(params)"
        
        let headers: HTTPHeaders = [
            "Authorization":"Bearer \(Constants.BEARER_TOKEN.rawValue)"
        ]
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                let profileModel = UserProfileModel()
                profileModel.id = data["id_str"].string
                profileModel.name = data["name"].string
                profileModel.screenName = data["screen_name"].string
                profileModel.bio = data["description"].string
                profileModel.followers = data["followers_count"].int
                profileModel.friends = data["friends_count"].int
                profileModel.joiningDate = data["created_at"].string
                profileModel.tweetCount = data["statuses_count"].int
                profileModel.isVerified = data["verified"].bool
                profileModel.profileImage = data["profile_image_url_https"].string
                profileModel.backgroundImage = data["profile_banner_url"].string
                profileModel.website = data["url"].string
                profileModel.isProtected = data["protected"].bool
                
                DispatchQueue.main.async {
                    completionHandler(profileModel)
                }
                
            case .failure(_):
                print("error")
            }
        }
    }
}

