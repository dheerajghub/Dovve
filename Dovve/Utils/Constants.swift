//
//  Constants.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 18/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

enum Constants:String {
    case CONSUMER_KEY = "r3Xf3R4URxGiXj3fumU5qTOYN" //ADD YOUR CONSUMER KEY HERE
    case CONSUMER_SECRET = "7wi7QxmJz63q9grc5UVHCA7HnTKp5CWTGvmqawss4o3G59vAFg" //ADD YOUR CONSUMER SECRET HERE.
    case BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAFkiHwEAAAAASFFbJQgIZHnt4ETjey3QGM4pkMk%3D7lJBBXpwao5cCen6v1CwUR2C3orfYDEmFmvAxoTo8nYw00RK7G" //ADD YOUR BEARER TOKEN HERE.
    case BASE_URL = "https://api.twitter.com"
}

struct CustomColors {
    static let appExtraLightGray = UIColor(red: 225/255, green: 232/255, blue: 237/255, alpha: 1)
    static let appLightGray = UIColor(red: 170/255, green: 184/255, blue: 194/255, alpha: 1)
    static let appDarkGray = UIColor(red: 101/255, green: 119/255, blue: 134/255, alpha: 1)
    static let appBlack = UIColor(red: 20/255, green: 23/255, blue: 26/255, alpha: 1)
    static let appBlue = UIColor(red: 29/255, green: 161/255, blue: 242/255, alpha: 1)
    static let appBackground = UIColor(red: 21/255, green: 33/255, blue: 43/255, alpha: 1)
}

struct CustomFonts {
    static let appFontBold = "HelveticaNeue-Bold"
    static let appFontMedium = "HelveticaNeue-Medium"
    static let appFont = "HelveticaNeue"
}
