//
//  GetFollowingStatus.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class GetFollowingStatus: NSObject {
    var isFollowing:Bool!
    
    static func fetchFollowingStatus(source_id:String, target_id:String, completionHandler: @escaping (GetFollowingStatus) -> ()){
        let url = "\(Constants.BASE_URL.rawValue)/1.1/friendships/show.json?source_id=\(source_id)&target_id=\(target_id)"
        
        let headers: HTTPHeaders = [
            "Authorization":"Bearer \(Constants.BEARER_TOKEN.rawValue)"
        ]
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                let statusModel = GetFollowingStatus()
                statusModel.isFollowing = data["relationship"]["source"]["following"].bool
                DispatchQueue.main.async {
                    completionHandler(statusModel)
                }
            case .failure(_):
                print("error")
            }
        }
    }
}
