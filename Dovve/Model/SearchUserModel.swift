//
//  SearchUserModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 02/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import Foundation

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages


class SearchUserModel:NSObject{
    
    var id:String!
    var name:String!
    var screenName:String!
    var bio:String!
    var isVerified:Bool!
    var profileImage:String!
    
    static func fetchSearchedUsers(view:UIViewController , params:String , query:String, completionHandler: @escaping ([SearchUserModel]) -> ()){
        
        let url = "\(Constants.BASE_URL.rawValue)/1.1/users/search.json?\(params)"
        let urlS = "\(Constants.BASE_URL.rawValue)/1.1/users/search.json"
        let authToken: String? = KeychainWrapper.standard.string(forKey: "authToken")
        let authTokenSecret:String? = KeychainWrapper.standard.string(forKey: "authTokenSecret")
        let model = TwitterSignatureParameters(
            user_id: "",
            max_id: "",
            oauthConsumerKey: Constants.CONSUMER_KEY.rawValue,
            oauthSignatureMethod: "HMAC-SHA1",
            oauthTimestamp: "\(Int(Date().timeIntervalSince1970))",
            oauthToken: authToken!,
            oauthVersion: "1.0",
            oauthNonce: "\(UUID().uuidString)",
            urlString: urlS,
            params: "\(query)"
        )
        
        let twitterOAuth = TwitterSwiftLite()
        let headers = twitterOAuth.makeHeaders(model, Constants.CONSUMER_SECRET.rawValue, authTokenSecret!)
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                if data["errors"][0]["message"].string == nil {
                    var searchModel = [SearchUserModel]()
                    let users = data
                    for i in 0..<users.count {
                        let userData = SearchUserModel()
                        userData.id = users[i]["id_str"].string
                        userData.name = users[i]["name"].string
                        userData.screenName = users[i]["screen_name"].string
                        userData.bio = users[i]["description"].string
                        userData.isVerified = users[i]["verified"].bool
                        userData.profileImage = users[i]["profile_image_url_https"].string
                        searchModel.append(userData)
                    }
                    
                    DispatchQueue.main.async {
                        completionHandler(searchModel)
                    }
                } else {
                    let message = data["errors"][0]["message"].string
                    view.showMessage(message!, type: .error)
                }
                
            case .failure(_):
                print("error")
            }
        }
    }
}


