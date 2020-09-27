//
//  NSAttributedString.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 22/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

func setUserInfoAttributes( _ name:String, _ userName:String , _ time:String, _ isVerified:Bool) -> NSAttributedString {
    let attributedText = NSMutableAttributedString(string:"\(name) " , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontMedium, size: 17)!, NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)])
    
    if isVerified {
        let font = UIFont.systemFont(ofSize: 16)
        let verifiyImg = UIImage(named:"verify")
        let verifiedImage = NSTextAttachment()
        verifiedImage.image = verifiyImg
        verifiedImage.bounds = CGRect(x: 0, y: (font.capHeight - 16).rounded() / 2, width: 16, height: 16)
        verifiedImage.setImageHeight(height: 16)
        let imgString = NSAttributedString(attachment: verifiedImage)
        attributedText.append(imgString)
    }
    
    attributedText.append(NSAttributedString(string: " @\(userName)" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFont, size: 17)! , NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
    
    let formattedT = time.parseTwitterDate()
    attributedText.append(NSAttributedString(string: " • \(formattedT ?? "")" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFont, size: 17)!, NSAttributedString.Key.foregroundColor: CustomColors.appDarkGray]))
    
    return attributedText
}

func setUserVerifiedNameAttribute( _ name:String , _ isVerified:Bool) -> NSAttributedString{
    let attributedText = NSMutableAttributedString(string:"\(name) " , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontBold, size: 22)!, NSAttributedString.Key.foregroundColor: UIColor.dynamicColor(.textColor)])
    
    if isVerified {
        let font = UIFont.systemFont(ofSize: 22)
        let verifiyImg = UIImage(named:"verify")
        let verifiedImage = NSTextAttachment()
        verifiedImage.image = verifiyImg
        verifiedImage.bounds = CGRect(x: 0, y: (font.capHeight - 22).rounded() / 2, width: 22, height: 22)
        verifiedImage.setImageHeight(height: 22)
        let imgString = NSAttributedString(attachment: verifiedImage)
        attributedText.append(imgString)
    }
    
    return attributedText
}
