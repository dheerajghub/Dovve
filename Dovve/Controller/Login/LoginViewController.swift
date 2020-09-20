//
//  LoginViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 18/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import TwitterKit

class LoginViewController: UIViewController {

    var bottomContraints:NSLayoutConstraint!
    
    let logoCard:UIView = {
        let v = UIView()
        v.translatesAutoresizingMaskIntoConstraints = false
        return v
    }()
    
    let appLogo:UIImageView = {
        let img = UIImageView()
        img.translatesAutoresizingMaskIntoConstraints = false
        img.layer.cornerRadius = 30
        img.image = UIImage(named: "logo")
        img.clipsToBounds = true
        return img
    }()
    
    lazy var loginCardView:LoginCardView = {
        let v = LoginCardView()
        v.controller = self
        v.translatesAutoresizingMaskIntoConstraints = false
        v.backgroundColor = .white
        v.layer.cornerRadius = 30
        return v
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = CustomColors.appExtraLightGray
        view.addSubview(loginCardView)
        view.addSubview(logoCard)
        logoCard.addSubview(appLogo)
        appLogo.alpha = 0
        self.appLogo.transform = CGAffineTransform(scaleX: 0.4, y: 0.4)
        setUpConstraints()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.6) {
            self.animateLoginCard()
        }
    }
    
    func setUpConstraints(){
        NSLayoutConstraint.activate([
            loginCardView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            loginCardView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            loginCardView.heightAnchor.constraint(equalToConstant: 300),
            
            logoCard.topAnchor.constraint(equalTo: view.topAnchor , constant: 20),
            logoCard.bottomAnchor.constraint(equalTo: loginCardView.topAnchor, constant: -20),
            logoCard.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 20),
            logoCard.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -20),
            
            appLogo.centerYAnchor.constraint(equalTo: logoCard.centerYAnchor),
            appLogo.centerXAnchor.constraint(equalTo: logoCard.centerXAnchor),
            appLogo.widthAnchor.constraint(equalToConstant: 130),
            appLogo.heightAnchor.constraint(equalToConstant: 130)
        ])
        
        bottomContraints = loginCardView.bottomAnchor.constraint(equalTo: view.bottomAnchor)
        bottomContraints.isActive = true
        bottomContraints.constant = 600
    }
    
    func animateLoginCard(){
        self.bottomContraints.constant = -30
        UIView.animate(withDuration: 0.6, delay: 0, usingSpringWithDamping: 1, initialSpringVelocity: 0.7, options: .curveEaseInOut, animations: {
            self.view.layoutIfNeeded()
        }, completion: { finish in
            UIView.animate(withDuration: 0.3) {
                self.appLogo.alpha = 1
                self.appLogo.transform = .identity
            }
        })
    }
    
    @objc func loginBtnPressed(){
        loginCardView.loginBtn.touchAnimation(s: loginCardView.loginBtn)
        let VC = CustomTabBarController()
        VC.modalPresentationStyle = .fullScreen
        self.present(VC, animated: true, completion: nil)
//        TWTRTwitter.sharedInstance().logIn { (session, err) in
//            if session != nil {
//                print("Login Succefully")
//                print(session?.authToken)
//                print(session?.authTokenSecret)
//                let VC = HomeViewController()
//                VC.modalPresentationStyle = .fullScreen
//                self.present(VC, animated: true, completion: nil)
//            } else {
//                print(err.debugDescription)
//            }
//        }
    }

}
