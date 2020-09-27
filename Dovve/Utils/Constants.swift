//
//  Constants.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 18/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

enum Constants:String {
    case CONSUMER_KEY = "n0W8QKwvyVmVYmhMpsutYRRby" //ADD YOUR CONSUMER KEY HERE
    case CONSUMER_SECRET = "G4qD4kffbyeJ4d1HlyeFSdraslYDZhQ6JcuzSIBZJoedFiU6H0" //ADD YOUR CONSUMER SECRET HERE.
    case BEARER_TOKEN = "AAAAAAAAAAAAAAAAAAAAAFkiHwEAAAAAEnPtBCJzJlPoobYYeCTqM414NEU%3D7ROcbRGw3LLJTZ5kgYIYAJsokCdefpUpCSvC5E3oTX27jM6Cz3" //ADD YOUR BEARER TOKEN HERE.
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
