//
//  UIViewController.swift
//  Dovve
//
//  Created by Dheeraj Kumar Sharma on 27/09/20.
//  Copyright © 2020 Dheeraj Kumar Sharma. All rights reserved.
//

import UIKit
import AVKit

extension UIViewController {
    
    func PushToProfile(_ userId:String , _ screenName:String) {
        let VC = UserProfileViewController()
        VC.userProfileId = userId
        VC.screenName = screenName
        navigationController?.pushViewController(VC, animated: true)
    }
    
    func PushProfileToProfile( _ userId:String , _ comparingFrom:String){
        if userId != comparingFrom {
            let VC = UserProfileViewController()
            VC.userProfileId = userId
            VC.screenName = ""
            navigationController?.pushViewController(VC, animated: true)
        }
    }
    
    func PushToImageDetailView( _ media:[TweetMediaData] , _ index:Int){
        let VC = ImageDetailViewController()
        let navVC = UINavigationController(rootViewController: VC)
        VC.imgString = media
        VC.indexRow = index
        navVC.modalPresentationStyle = .fullScreen
        self.present(navVC, animated: true, completion: nil)
    }
    
    func ShowVieoWithUrl(_ url:String){
        let videoURL = URL(string: url)
        let player = AVPlayer(url: videoURL!)
        let playerViewController = AVPlayerViewController()
        playerViewController.player = player

        self.present(playerViewController, animated: true) {
          player.play()
        }
    }
    
    func SearchForHashtag(_ hashtag:String){
        let VC = SearchWithCategoryViewController()
        VC.query = "%23\(hashtag)"
        VC.query_str = "#\(hashtag)"
        VC.query_user = hashtag
        navigationController?.pushViewController(VC, animated: true)
    }
    
}
