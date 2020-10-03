//
//  TrendsModel.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 03/10/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftyJSON
import SwiftKeychainWrapper
import GSMessages

class GetTrends: NSObject {
    var name:String!
    var query:String!
    var tweetVolume:Int!
    
    static func fetchTrends(view:UIViewController, woeid:String, completionHandler: @escaping ([GetTrends]) -> ()){
        let url = "\(Constants.BASE_URL.rawValue)/1.1/trends/place.json?id=\(woeid)"
        let headers: HTTPHeaders = [
            "Authorization":"Bearer \(Constants.BEARER_TOKEN.rawValue)"
        ]
        let method: HTTPMethod = .get
        
        AF.request(url, method: method, encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                let data = JSON(response.value!)
                let trendList = data[0]["trends"]
                var trends = [GetTrends]()
                for i in 0..<trendList.count {
                    let trend = GetTrends()
                    trend.name = trendList[i]["name"].string
                    trend.query = trendList[i]["query"].string
                    trend.tweetVolume = trendList[i]["tweet_volume"].int
                    trends.append(trend)
                }
                DispatchQueue.main.async {
                    completionHandler(trends)
                }
            case .failure(_):
                print("error")
                view.showMessage("No internet", type: .error)
            }
        }
    }
}
