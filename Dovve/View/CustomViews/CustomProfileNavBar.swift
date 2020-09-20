//
//  CustomProfileNavBar.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 20/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class CustomProfileNavBar: UIView {

    var controller:ProfileViewController?
    
    let cardImageView:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.image = UIImage(named: "demo")
//        img.backgroundColor = .white
        img.contentMode = .scaleAspectFill
        img.clipsToBounds = true
        return img
    }()
    
    let titleLabel:UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.numberOfLines = 0
        return l
    }()

    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(cardImageView)
        addSubview(titleLabel)
        setUpConstraints()
        titleLabel.transform = CGAffineTransform(translationX: 0, y: +50)
        setAttributedText("Dheeraj", tweetCount: "43")
        
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
            
            titleLabel.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -10),
            titleLabel.centerXAnchor.constraint(equalTo: centerXAnchor),
        ])
    }
    
    func setAttributedText(_ name:String , tweetCount:String) {
        let attributedText = NSMutableAttributedString(string:"\(name)\n" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFontBold, size: 20)!, NSAttributedString.Key.foregroundColor: UIColor.white])
        
        attributedText.append(NSAttributedString(string: "\(tweetCount) Tweets" , attributes:[NSAttributedString.Key.font: UIFont(name: CustomFonts.appFont, size: 16)! , NSAttributedString.Key.foregroundColor: CustomColors.appExtraLightGray]))
        
        titleLabel.attributedText = attributedText
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

}
