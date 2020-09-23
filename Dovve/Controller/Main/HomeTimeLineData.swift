//
//  HomeTimeLineData.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 23/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import Alamofire
import SwiftKeychainWrapper
import SwiftyJSON

class HomeTimeLineData: UIViewController {

    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        fetchHomeTimeline()
    }
    
    public func fetchHomeTimeline() {
        
        let url = "\(Constants.BASE_URL.rawValue)/1.1/statuses/home_timeline.json"
//        let url = "https://bb08dc8de14dbb0fda369a65b0aa4650.m.pipedream.net"
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
            urlString: url
        )
        
        let twitterOAuth = TwitterSwiftLite()
        let headers = twitterOAuth.makeHeaders(model, Constants.CONSUMER_SECRET.rawValue, authTokenSecret!)
        let method: HTTPMethod = .get
        
        AF.request(url, method: method , encoding: URLEncoding.httpBody, headers: headers).responseJSON { response in
            switch(response.result){
            case .success(_):
                print(JSON(response.value!))
            case .failure(_):
                print("error")
            }
        }
        
    }

}
