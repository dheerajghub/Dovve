//
//  Constants.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 18/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

enum Constants:String {
    case CONSUMER_KEY = "nyVPnCh2FfeItVNkCRJTkMu12" //ADD YOUR CONSUMER KEY HERE
    case CONSUMER_SECRET = "abMVQNZjoGC2lClgWDKA6mGnrU3S5GZXySiMmXDVp9NKGwKxGJ" //ADD YOUR CONSUMER SECRET HERE.
    case BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAFkiHwEAAAAAb4GWKO5L3QlqO4wF2Y24XMhzic0%3DVrCjk8hUXic7UUAb7Bfc8m4gf4w1Phmo9inREeVH2rPztRQ1vS" //ADD YOUR BEARER TOKEN HERE.
    case BASE_URL = "https://api.twitter.com"
}

struct CustomColors {
    static let appExtraLightGray = UIColor(red: 225/255, green: 232/255, blue: 237/255, alpha: 1)
    static let appLightGray = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1)
    static let appDarkGray = UIColor(red: 101/255, green: 119/255, blue: 134/255, alpha: 1)
    static let appBlack = UIColor(red: 20/255, green: 23/255, blue: 26/255, alpha: 1)
    static let appBlue = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    static let appBackground = UIColor(red: 21/255, green: 33/255, blue: 43/255, alpha: 1)
    static let appRed = UIColor(red: 225/255, green: 57/255, blue: 95/255, alpha: 1)
    static let appSecondaryBackground = UIColor(red: 15/255, green: 24/255, blue: 34/255, alpha: 1)
}

struct CustomFonts {
    static let appFontBold = "HelveticaNeue-Bold"
    static let appFontMedium = "HelveticaNeue-Medium"
    static let appFont = "HelveticaNeue"
    static let appFontThin = "HelveticaNeue-Thin"
}
