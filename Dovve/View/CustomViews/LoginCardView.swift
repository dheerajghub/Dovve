//
//  LoginCardView.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 18/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit

class LoginCardView: UIView {

    var controller:LoginViewController?{
        didSet{
            loginBtn.addTarget(controller, action: #selector(LoginViewController.loginBtnPressed), for: .touchUpInside)
        }
    }
    
    let title:UILabel = {
        let l = UILabel()
        l.font = UIFont(name: CustomFonts.appFontBold, size: 30)
        l.text = "Welcome folks!"
        l.textColor = CustomColors.appBlack
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let subTitle:UILabel = {
        let l = UILabel()
        l.font = UIFont(name: CustomFonts.appFont, size: 18)
        l.text = "Get started with Dovve! And see what's happening in the world right now"
        l.numberOfLines = 0
        l.textAlignment = .center
        l.textColor = CustomColors.appDarkGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let smallText:UILabel = {
        let l = UILabel()
        l.font = UIFont(name: CustomFonts.appFontMedium, size: 15)
        l.text = "Login with twitter"
        l.textAlignment = .center
        l.textColor = CustomColors.appLightGray
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    let loginBtn:UIButton = {
        let btn = UIButton()
        btn.translatesAutoresizingMaskIntoConstraints = false
        btn.backgroundColor = CustomColors.appBlue
        btn.layer.cornerRadius = 30
        btn.setTitle("Login", for: .normal)
        btn.setTitleColor(.white, for: .normal)
        btn.titleLabel?.font = UIFont(name: CustomFonts.appFontBold, size: 20)
        return btn
    }()
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        addSubview(title)
        addSubview(subTitle)
        addSubview(loginBtn)
        addSubview(smallText)
        setUpConstraints()
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            title.topAnchor.constraint(equalTo: topAnchor, constant: 30),
            title.centerXAnchor.constraint(equalTo: centerXAnchor),
            
            subTitle.topAnchor.constraint(equalTo: title.bottomAnchor, constant: 15),
            subTitle.centerXAnchor.constraint(equalTo: centerXAnchor),
            subTitle.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            subTitle.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            smallText.bottomAnchor.constraint(equalTo: loginBtn.topAnchor, constant: -7),
            smallText.centerXAnchor.constraint(equalTo: centerXAnchor),
            smallText.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            smallText.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            
            loginBtn.bottomAnchor.constraint(equalTo: bottomAnchor, constant: -30),
            loginBtn.leadingAnchor.constraint(equalTo: leadingAnchor, constant: 30),
            loginBtn.trailingAnchor.constraint(equalTo: trailingAnchor, constant: -30),
            loginBtn.heightAnchor.constraint(equalToConstant: 60),
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
}
