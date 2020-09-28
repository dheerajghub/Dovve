//
//  CustomUserProfileNavBar.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomUserProfileNavBar: UIView {

     var controller:UserProfileViewController?
        
    let textOverlayView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.layer.masksToBounds = true
        return v
    }()
    
    let cardImageView:CustomImageView = {
        let img = CustomImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "demo")
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let cardBackView:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = UIColor.dynamicColor(.secondaryBackground)
        return v
    }()
    
    let titleLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        l.textAlignment = .center
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardImageView)
        addSubview(cardBackView)
        addSubview(textOverlayView)
        textOverlayView.addSubview(titleLabel)
        textOverlayView.pin(to: self)
        setUpConstraints()
        titleLabel.transform = CGAffineTransform(translationX: 0, y: +50)
        
        let blurEffect = UIBlurEffect(style: UIBlurEffect.Style.dark)
        let blurEffectView = UIVisualEffectView(effect: blurEffect)
        blurEffectView.frame = cardImageView.bounds
        blurEffectView.autoresizingMask = [.flexibleWidth, .flexibleHeight]
        cardImageView.addSubview(blurEffectView)
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            cardImageView.topAnchor.constraint(equalTo: topAnchor),
            cardImageView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardImageView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardImageView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            cardBackView.topAnchor.constraint(equalTo: topAnchor),
            cardBackView.leadingAnchor.constraint(equalTo: leadingAnchor),
            cardBackView.trailingAnchor.constraint(equalTo: trailingAnchor),
            cardBackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setAttributedText(_ name:String , tweetCount:String , isProtected:Bool) {
        let attributedText = NSMutableAttributedString(string:"\(name)" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontBold, size: 18)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        if isProtected == false {
            attributedText.append(NSAttributedString(string: "\n\(tweetCount) Tweets" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFont, size: 16)! , NSAttributedString.Key.foregroundColor: CustomColors.appExtraLightGray]))
        }
        titleLabel.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
