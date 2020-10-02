//
//  Constants.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 18/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

enum Constants:String {
    case CONSUMER_KEY = "GtfTfsRV7szIC8ERSgsQ3kHeN" //ADD YOUR CONSUMER KEY HERE
    case CONSUMER_SECRET = "mk8uSVpJ2biKoXVSOwOFpb9LI05m9pSbMLzMmEbW3PCZhQrgLP" //ADD YOUR CONSUMER SECRET HERE.
    case BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAFkiHwEAAAAA6dHMxPE3JMDVQ%2FuouX4PLGPE46c%3DRyr5KtAqmBN2Q1YnyvgQkt8YiAfNNuLYCASBOSPnF3YvI3K4rf" //ADD YOUR BEARER TOKEN HERE.
    case BASE_URL = "https://api.twitter.com"
    //MARK:- Enter your WOEID as i belong from india my id is this 2282863 (this id is used to get trending tweets of your country or place!)
    case WOEID = "2282863"
}

struct CustomColors {
    static let appExtraLightGray = UIColor(red: 225/255, green: 232/255, blue: 237/255, alpha: 1)
    static let appLightGray = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1)
    static let appDarkGray = UIColor(red: 101/255, green: 119/255, blue: 134/255, alpha: 1)
    static let appBlack = UIColor(red: 20/255, green: 23/255, blue: 26/255, alpha: 1)
    static let appBlue = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    static let appBackground = UIColor(red: 21/255, green: 33/255, blue: 43/255, alpha: 1)
    static let appRed = UIColor(red: 225/255, green: 57/255, blue: 95/255, alpha: 1)
}

struct CustomFonts {
    static let appFontBold = "HelveticaNeue-Bold"
    static let appFontMedium = "HelveticaNeue-Medium"
    static let appFont = "HelveticaNeue"
}
